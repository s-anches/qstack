module OmniauthMacros
  def mock_auth_hash(provider, email = nil)
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      provider: provider.to_s,
      uid: '123545',
      info: {
        email: email
      },
      extra: {
        raw_info: {
          email: email
        }
      }})
  end
end
