defmodule TenExTakeHomeWeb.PageController do
  use TenExTakeHomeWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    public_key = Application.get_env(:ten_ex_take_home, :public_key)
    private_key = Application.get_env(:ten_ex_take_home, :private_key)

    ts = to_string(:rand.uniform(9))
    hash_target = ts <> private_key <> public_key
    dbg(hash_target)

    md5_hash =
      :crypto.hash(:md5, hash_target)
      |> Base.encode16(case: :lower)

    dbg(md5_hash)

    ts = "ts=#{ts}"
    apikey = "&apikey=#{public_key}"
    hash = "&hash=#{md5_hash}"

    url = ts <> apikey <> hash

    # http://gateway.marvel.com/v1/public/comics?ts=1&apikey=1234&hash=ffd275c5130566a2916217b101f26150

    req_url = form_url(url)
    build_request(req_url)
    render(conn, :home, layout: false)
  end

  def form_url(url) do
    "https://gateway.marvel.com/v1/public/comics?" <> url
  end

  def build_request(req_url) do
    result =
      Finch.build(:get, req_url)
      |> Finch.request(TenExTakeHome.Finch)

    dbg(result)
  end
end

# All calls to the Marvel Comics API must pass your public key via an “apikey” parameter.

# ts - a timestamp (or other long string which can change on a request-by-request basis)
# hash - a md5 digest of the ts parameter, your private key and your public key
#  (e.g. md5(ts+privateKey+publicKey)
