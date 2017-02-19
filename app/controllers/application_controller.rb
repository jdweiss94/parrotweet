class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def getTranslations(tweet, languages)
    result = []
    hashtags = tweet.scan(/#[a-zA-Z0-9]+/)
    tweet = tweet.gsub(/#[a-zA-Z0-9]+/, 'hashtagtoken')
    
    languages.each do |lang|
      myText = "translation of " +tweet+ " to " + lang.to_s
      response = open('http://transltr.org/api/translate?text=' + tweet + '&to=' + lang.to_s + "&from=en").read
      json = JSON.parse(response)
      hashtags.each_with_index do |tag, index|
        json["translationText"].sub!(/[hH]ashtagtoken/, hashtags[index])
      end
      result.push(json)
    end
    result
  end
  helper_method :translate
end
