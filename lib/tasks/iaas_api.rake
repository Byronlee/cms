namespace :iaas do
  desc 'Modify load balancer backend attributes'
  task :web3_preview_lbp => :environment do
    Deploy::Iaas.web_lbp('pek2', 'lbb-pm71b6jb', 'lbp-718wod2g', '8093', '1')
    Deploy::Iaas.apply_policy('pek2', 'lb-ym7veism')
  end
  task :web4_preview_lbp => :environment do
    Deploy::Iaas.web_lbp('pek2', 'lbb-olx8pelq', 'lbp-718wod2g', '8098', '1')
    Deploy::Iaas.apply_policy('pek2', 'lb-ym7veism')
  end
  task :online_lbp => :environment do
    Deploy::Iaas.web_lbp('pek2', 'lbb-pm71b6jb', '', '8093', '5')
    #Deploy::Iaas.web_lbp('pek2', 'lbb-olx8pelq', '', '8098', '5')
    Deploy::Iaas.apply_policy('pek2', 'lb-ym7veism')
  end

  desc 'Block ip firewall'
  task :block_ip_firewall => :environment do
     Deploy::Iaas.block_ip_firewall(Settings.deploy.zone,
       Settings.deploy.firewall.security_group_rule, Settings.deploy.firewall.weight)
  end
end
