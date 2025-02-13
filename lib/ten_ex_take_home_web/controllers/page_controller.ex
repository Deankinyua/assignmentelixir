defmodule TenExTakeHomeWeb.PageController do
  use TenExTakeHomeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    dbg(Application.get_env(:ten_ex_take_home, :public_key))
    dbg(Application.get_env(:ten_ex_take_home, :private_key))

    md5_hash =
      :crypto.hash(:md5, "1234abcd")
      |> Base.encode16(case: :lower)

    dbg(md5_hash)

    # user_url = form_url("v1/public")
    # build_request(user_url)
    render(conn, :home, layout: false)
  end

  def form_url(username) do
    "https://gateway.marvel.com/" <> username
  end

  def build_request(user_url) do
    Finch.build(:get, user_url)
    |> Finch.request(TenExTakeHome.Finch)
  end
end

# All calls to the Marvel Comics API must pass your public key via an “apikey” parameter.

# ts - a timestamp (or other long string which can change on a request-by-request basis)
# hash - a md5 digest of the ts parameter, your private key and your public key
#  (e.g. md5(ts+privateKey+publicKey)
