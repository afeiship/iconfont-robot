class Iconfont
  def download
    Http.get(CONFIG["url"]) do |http, request|
      request["Cookie"] = CONFIG["cookie"]
    end
  end

  def detail
    res = Http.get(CONFIG["detail"]) do |http, request|
      request["Cookie"] = CONFIG["cookie"]
    end
    JSON.parse(res.body)
  end

  def update(update_at)
    CONFIG.set("updated_at", update_at)
    File.write("./config.json", JSON.pretty_generate(CONFIG))
  end

  def changed?(updated_at)
    old = CONFIG.get("updated_at")
    now = updated_at
    old != now
  end
end
