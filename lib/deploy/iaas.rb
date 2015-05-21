require 'openssl'
require 'base64'
require "faraday"
# author xiaobo
# Deploy::Iaas.web3_lbp(zone, backend_id, policy_id)
# Deploy::Iaas.apply_policy(zone, loadbalancer_id)
class Deploy::Iaas

  PATH = File.expand_path('..', __FILE__)
  KEY = 'CIKMCGEHRZEDJXPDRBJK'
  SECRET = 'Xqc98lWlKSEJW8QZK6PLCD9c1el97MwkvwzEqiaM'
  WHITE_LIST = ['119.254.103.59']
  AGENT_BLACK_LIST = []

  def initialize(url, key, secret)
    @url, @key, @secret = url, key, secret
  end

  def signature(url = @url, key = @key, secret = @secret)
    common_params = "&time_stamp=#{CGI::escape(Time.now.strftime("%FT%TZ"))}&access_key_id=#{key}&version=1&signature_method=HmacSHA256&signature_version=1"
    string_uri = url.scan(URI.regexp)[0][7] + common_params
    sort_string_uri = string_uri.split('&').sort.join('&')
    make_string_to_sign = "GET\n/iaas/\n#{sort_string_uri}"
    hash_string_to_sign  = OpenSSL::HMAC.digest('sha256', secret, make_string_to_sign)
    signature_string = Base64.encode64(hash_string_to_sign).strip
    signature_url = "#{url + common_params}&signature=#{CGI::escape(signature_string)}"
  end

  def send_msg(url)
    response = Faraday.get url
    puts response.body
  end

  class << self
    def web_lbp(zone, backend_id, policy_id, port, weight)
      url = "https://api.qingcloud.com/iaas/?action=ModifyLoadBalancerBackendAttributes&loadbalancer_backend=#{backend_id}&port=#{port}&weight=#{weight}&disabled=0&loadbalancer_policy_id=#{policy_id}&zone=#{zone}"
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

    def block_ip_firewall(zone, security_group_rule, priority )
      #security_group_rule = 'sgr-69oawmvq'
      #priority = 1
      #zone = 'pek2'
      threshold = 20
      protocol, direction, rule_action = 'tcp', '0', 'drop'
      val1, val2 = '80', '443'
      host_name = %x{hostname}.strip
      data = %x{sh "#{PATH}/run"}.split(/[\n]+/).collect {|b| b.split(' ')}
      msg = data.pop
      end_time, start_time = DateTime.strptime(data.pop[0], "%d/%b/%Y:%T"), DateTime.strptime(data.pop[0].gsub('[', ''),"%d/%b/%Y:%T")
      click_ip = data.select {|x| x[0].to_i > threshold }[0]
      unless click_ip.blank?
        click = click_ip[0]
        ip = click_ip[1]
        check_time = end_time.to_i - start_time.to_i
        frequency = click.to_i / check_time
        if frequency > 2
          if WHITE_LIST.include? ip
            #notification "#{host_name}: W: #{ check_time } 秒内 http://ip.cn/?ip=#{ip} 请求次数为 #{click} 次 攻击频率 #{frequency} 次/秒 此ip为白名单允许访问 \n #{msg}"
            notification2 json_msg( ip, host_name, frequency, click, check_time, msg, "#2CC99C", "白" )
          else
            #notification "#{host_name}: B: #{ check_time } 秒内 http://ip.cn/?ip=#{ip} 请求次数为 #{click} 次 攻击频率 #{frequency} 次/秒 此ip为黑名单被封锁 \n #{msg}"
            notification2 json_msg( ip, host_name, frequency, click, check_time, msg, "#F35A00", "黑" )
            url = "https://api.qingcloud.com/iaas/?action=ModifySecurityGroupRuleAttributes&security_group_rule_name=#{host_name}-auto-black&security_group_rule=#{security_group_rule}&priority=#{priority}&rule_action=#{rule_action}&protocol=#{protocol}&direction=#{direction}&val1=#{val1}&val2=#{val2}&val3=#{ip}&zone=#{zone}"
            signature_obj = self.new(url, KEY, SECRET)
            signature_url = signature_obj.signature
            #puts signature_url
            signature_obj.send_msg signature_url
            apply_firewall('pek2', 'sg-do5avfp6')
          end
        end
      end

    end

    def apply_firewall(zone, security_group)
      #zone = 'pek2'
      #security_group = 'sg-do5avfp6'
      host_name = %x{hostname}.strip
      apply_url = "https://api.qingcloud.com/iaas/?action=ApplySecurityGroup&security_group=#{security_group}&zone=#{zone}"
      signature_obj = self.new(apply_url, KEY, SECRET)
      signature_url = signature_obj.signature
      #puts signature_url
      signature_obj.send_msg signature_url
    end

    def notification text
      url = 'https://hooks.slack.com/services/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'
      Faraday.post url , {
        payload: JSON.generate({ text: text })
      }
    end

    def notification2 json
      url = 'https://hooks.slack.com/services/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'
      Faraday.post url , { payload: json }
    end

    def json_msg(*params)
      {
        attachments: [{
            fallback: "防火墙告警 - IP: #{params[0]} 被加入#{params[7]}名单: http://ip.cn/?ip=#{params[0]}",
            title: "<http://ip.cn/?ip=#{params[0]}/|IP: #{params[0]}> - 被加入#{params[7]}名单",
            fields: [{
              title: "主机",
              value: "#{params[1]}",
              short: true
             },
             {
              title: "请求频率",
              value: "#{params[2]} rps / #{params[3]} hits in #{params[4]} s",
              short: true
            },
            {
              title: "请求 Log 样例",
              value: "#{params[5]}",
              short: false
            }
          ],
          color: "#{params[6]}"#F35A00
      }]
      }.to_json
    end

  end

end
