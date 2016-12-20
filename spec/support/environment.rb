def set_env(key, value)
  ENV[key] = value
end

def unset_env(key)
  ENV.delete(key)
end

def set_http_referer(path)
  request.env['HTTP_REFERER'] = path
end