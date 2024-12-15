namespace :tokens do
  desc "Remove expired tokens"
  task clean_expired: :environment do
    Token.where("expires_at < ?", Time.current).delete_all
  end
end
