namespace :iaas do
  desc 'Modify load balancer backend attributes'
  task :web1_preview_lbp => :environment do
    Deploy::Iaas.web_lbp('pek2', 'lbb-yd5i1k0c', 'lbp-z6agbjzn', '8091', '1')
    Deploy::Iaas.web_lbp('pek2', 'lbb-35k2e7ic', 'lbp-z6agbjzn', '8091', '1')
    Deploy::Iaas.apply_policy('pek2', 'lb-3hczjbvo')
  end
  task :web1_online_lbp => :environment do
    Deploy::Iaas.web_lbp('pek2', 'lbb-yd5i1k0c', '', '8091', '5')
    Deploy::Iaas.web_lbp('pek2', 'lbb-35k2e7ic', '', '8091', '1')
    Deploy::Iaas.apply_policy('pek2', 'lb-3hczjbvo')
  end

  desc 'Block ip firewall'
  task :block_ip_firewall => :environment do
     Deploy::Iaas.block_ip_firewall(Settings.deploy.zone,
       Settings.deploy.firewall.security_group_rule, Settings.deploy.firewall.weight)
  end
end
