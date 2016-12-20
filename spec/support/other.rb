def bcrypt(salt)
  BCrypt::Password.new(salt)
end