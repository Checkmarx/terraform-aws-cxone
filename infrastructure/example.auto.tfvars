
# METADATA
deployment_id = ""
environment   = ""
owner         = ""
aws_profile   = ""
aws_region    = ""

#VPC
vpc_cidr = ""

vpc = {
  create                    = false
  single_nat                = false
  nat_per_az                = false
  existing_cidr_blocks      = [""]
  existing_vpc_id           = ""
  existing_public_subnets   = []
  existing_subnet_ids       = []
  existing_db_subnets_group = ""
  existing_db_subnets       = []
}

# Security
sig = {
  create                     = true
  existing_sig_k8s_to_dbs_id = ""
}

# KMS
kms = {
  create           = false
  existing_kms_arn = "arn:aws:kms:eu-west-1:941355383184:key/4ecee642-7047-467f-ba19-9b5c03aba45f"
}

# EKS
eks_cluster_version = "1.24"
coredns = {
  resolve_conflicts = "OVERWRITE"
  version           = ""
}

kubeproxy = {
  resolve_conflicts = "OVERWRITE"
  version           = ""
}

vpccni = {
  resolve_conflicts = "OVERWRITE"
  version           = ""
}

# RDS
postgres_nodes = {
  create              = false
  auto_scaling_enable = false
  count               = 1
  max_count           = 0
  instance_type       = "db.r6g.large"
}

# REDIS
redis_nodes = {
  create             = false
  instance_type      = "cache.m6g.large"
  number_of_shards   = 3
  replicas_per_shard = 1
}