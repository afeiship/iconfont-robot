class Iconfont
  def initialize(cookie, url)
    @cookie = cookie
    @url = url
  end

  def download
    Http.get(@url) do |http, request|
      request["Cookie"] = @cookie
    end
  end
end
