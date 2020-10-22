// Derby
# AWS Transit Module Region 1
module "aws_transit_1" {
  source         = "terraform-aviatrix-modules/aws-transit-firenet/aviatrix"
  version        = "1.1.1"
  cidr           = var.aws_transit_cidr1
  region         = var.aws_region1
  account        = var.aws_account_name
  insane_mode    = var.insane
  instance_size  = var.aws_hpe_gw_size
  firewall_image = var.firewall_image
}

# AWS Transit Module Region 2
module "aws_transit_2" {
  source         = "terraform-aviatrix-modules/aws-transit-firenet/aviatrix"
  version        = "1.1.1"
  cidr           = var.aws_transit_cidr2
  region         = var.aws_region2
  account        = var.aws_account_name
  insane_mode    = var.insane
  instance_size  = var.aws_hpe_gw_size
  firewall_image = var.firewall_image
}

# AWS Spoke 1 Region 1
module "aws_spoke1" {
  source        = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version       = "1.1.1"
  name          = var.aws_spoke_gw_name_1
  cidr          = var.aws_spoke_vpc_cidr_1
  region        = var.aws_region1
  account       = var.aws_account_name
  insane_mode   = var.insane
  instance_size = var.aws_hpe_gw_size
  ha_gw         = var.ha_enabled
  transit_gw    = module.aws_transit_1.transit_gateway.gw_name
}

# AWS Spoke 2 Region 1
module "aws_spoke2" {
  source        = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version       = "1.1.1"
  name          = var.aws_spoke_gw_name_2
  cidr          = var.aws_spoke_vpc_cidr_2
  region        = var.aws_region1
  account       = var.aws_account_name
  insane_mode   = var.insane
  instance_size = var.aws_hpe_gw_size
  ha_gw         = var.ha_enabled
  transit_gw    = module.aws_transit_1.transit_gateway.gw_name
}

# AWS Spoke 3 Region 1
module "aws_spoke3" {
  source        = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version       = "1.1.1"
  name          = var.aws_spoke_gw_name_3
  cidr          = var.aws_spoke_vpc_cidr_3
  region        = var.aws_region1
  account       = var.aws_account_name
  insane_mode   = var.insane
  instance_size = var.aws_hpe_gw_size
  ha_gw         = var.ha_enabled
  transit_gw    = module.aws_transit_1.transit_gateway.gw_name
}

# AWS Spoke 4 Region 2
module "aws_spoke4" {
  source        = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version       = "1.1.1"
  name          = var.aws_spoke_gw_name_4
  cidr          = var.aws_spoke_vpc_cidr_4
  region        = var.aws_region2
  account       = var.aws_account_name
  insane_mode   = var.insane
  instance_size = var.aws_hpe_gw_size
  ha_gw         = var.ha_enabled
  transit_gw    = module.aws_transit_2.transit_gateway.gw_name
}

# AWS Spoke 5 Region 2
module "aws_spoke5" {
  source        = "terraform-aviatrix-modules/aws-spoke/aviatrix"
  version       = "1.1.1"
  name          = var.aws_spoke_gw_name_5
  cidr          = var.aws_spoke_vpc_cidr_5
  region        = var.aws_region2
  account       = var.aws_account_name
  insane_mode   = var.insane
  instance_size = var.aws_hpe_gw_size
  ha_gw         = var.ha_enabled
  transit_gw    = module.aws_transit_2.transit_gateway.gw_name
}

# Multi region Multi-Cloud transit peering
module "transit-peering" {
  source           = "terraform-aviatrix-modules/mc-transit-peering/aviatrix"
  version          = "1.0.0"
  transit_gateways = [module.aws_transit_1.transit_gateway.gw_name, module.aws_transit_2.transit_gateway.gw_name]
}