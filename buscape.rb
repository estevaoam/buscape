require 'httparty'

class BuscaPe
  include HTTParty
  
  BASE_URI = "sandbox.buscape.com/service"
  @application_id = "<your_application_id_here>"
  
  @uris = {
    :categories => "findCategoryList",
    :products => "findProductList",
    :ratings => "viewUserRatings",
    :oferts => "findOfferList",
    :details => "viewProductDetails"
  }
  
  @params = {
    :category => "categoryId",
    :product => "productId",
    :top_products => "topProducts",
    :seller => "sellerId"
  }
  
  @data = {}
  
  private
  
  def self.method_missing(method, *args, &block)
    if @uris.map {|v, k| v }.include? method
      self.fetch_api(method)
    else
      @data.merge!({method => args[0]})
      self
    end
  end
  
  def self.fetch_api(method)
    raise "Method '#{method}' doesn't exist!" if @uris[method].blank?
    
    @uris[method] = "viewSellerDetails" if method === :details && !@data[:seller].blank? && @data[:product].blank?
    
    url = "http://#{BASE_URI}/#{@uris[method]}/#{@application_id}/"

    @data.each { |sym, value|
      url += ((url[-1, 1] == "/") ? "?" : "&") + "#{(@params[sym].blank?) ? sym.to_s : @params[sym]}=#{value}" 
    }
    
    self.get(url)
  end
end
