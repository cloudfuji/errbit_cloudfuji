Rails.application.routes.draw do
  begin
    cloudfuji_routes

    if Cloudfuji::Platform.on_cloudfuji?
      # Setup cloudfuji authentication routes
      devise_cloudfuji_authenticatable
    end
  rescue => e
    puts "Error loading the Cloudfuji routes:"
    puts "#{e.inspect}"
  end
end
