defmodule SessionsApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils
  import Dynamo.HTTP.Session


  get "/" do
    user_id = get_session conn, :user_id

    IO.inspect get_session(conn)

    if user_id do
      IO.inspect User.get(user_id).public_attributes
      json_response [user: User.get(user_id).public_attributes], conn
    else
      json_response [error: "no session"], conn
    end
  end


  post "/" do
    {:ok, params} = conn.req_body
    |> JSEX.decode

    {results, count} = User.search("config_type:user AND username:#{params["username"]}")

    if length(results) > 0 do
      result = results |> hd
      if User.valid_password?(result, params["password"]) do
        json_response [user: result.public_attributes], put_session(conn, :user_id, result.id)
      else
        json_response [error: "Please check your login credentials"], conn
      end
    else
      json_response [error: "Maybe you don't have an account?"], conn
    end
  end


  delete "/" do
    json_response [ok: "logged out"], delete_session(conn, :user_id)
  end
end
