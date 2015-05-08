require 'openssl'
require 'base64'
require "faraday"
# author xiaobo
# Deploy::Iaas.web3_lbp(zone, backend_id, policy_id)
# Deploy::Iaas.apply_policy(zone, loadbalancer_id)
class Deploy::Iaas

  KEY = 'CIKMCGEHRZEDJXPDRBJK'
  SECRET = 'Xqc98lWlKSEJW8QZK6PLCD9c1el97MwkvwzEqiaM'

  def initialize(url, key, secret)
    @url, @key, @secret = url, key, secret
  end

  def signature(url = @url, key = @key, secret = @secret)
    common_params = "&time_stamp=#{CGI::escape(Time.now.strftime("%FT%TZ"))}&access_key_id=#{key}&version=1&signature_method=HmacSHA256&signature_version=1"
    string_uri = url.scan(URI.regexp)[0][7] + common_params
    sort_string_uri = string_uri.split('&').sort.join('&')
    make_string_to_sign = "GET\n/iaas/\n#{sort_string_uri}"
    hash_string_to_sign  = OpenSSL::HMAC.digest('sha256', secret, make_string_to_sign)
    signature_string = Base64.encode64(hash_string_to_sign).strip()
    signature_url = "#{url + common_params}&signature=#{CGI::escape(signature_string)}"
  end

  def send_msg(url)
    response = Faraday.get url
    puts response.body
  end

  class << self
    def web3_lbp(zone, backend_id, policy_id)
      url = "https://api.qingcloud.com/iaas/?action=ModifyLoadBalancerBackendAttributes&loadbalancer_backend=#{backend_id}&port=8093&weight=1&disabled=0&loadbalancer_policy_id=#{policy_id}&zone=#{zone}"
      signature_obj = self.new(url, KEY, SECRET)
      signature_url = signature_obj.signature
      #puts signature_url
      signature_obj.send_msg signature_url
    end

    def apply_policy(zone, loadbalancer_id)
      url = "https://api.qingcloud.com/iaas/?action=UpdateLoadBalancers&loadbalancers.1=#{loadbalancer_id}&zone=#{zone}"
      signature_obj = self.new(url, KEY, SECRET)
      signature_url = signature_obj.signature
      #puts signature_url
      signature_obj.send_msg signature_url
    end
  end

end
