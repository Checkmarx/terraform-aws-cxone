# tfsec:ignore:aws-eks-encrypt-secrets
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.11.0"

  create = true

  cluster_name    = local.deployment_id
  cluster_version = var.eks_cluster_version

  cluster_enabled_log_types = ["audit", "api", "authenticator", "scheduler"]

  cluster_endpoint_private_access = var.enable_private_endpoint
  cluster_endpoint_public_access  = var.enable_public_endpoint

  vpc_id     = local.vpc_id
  subnet_ids = local.subnets

  enable_irsa = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = var.coredns.resolve_conflicts
    }
    kube-proxy = {
      resolve_conflicts = var.kubeproxy.resolve_conflicts
    }
    vpc-cni = {
      resolve_conflicts = var.vpccni.resolve_conflicts
    }
  }

  cluster_encryption_config = [
    {
      provider_key_arn = local.kms_arn
      resources        = ["secrets"]
    }
  ]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    vpc_security_group_ids = [
      module.eks.cluster_primary_security_group_id,
      module.eks.cluster_security_group_id,
      local.sig_k8s_to_dbs_id
    ]
  }

  # aws-auth configmap
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = module.ast_default.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.ast_sast_engines.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.ast_sast_medium_engines.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.ast_sast_large_engines.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.ast_sast_extra_large_engines.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.ast_sast_xxl_engines.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.kics_nodes_engines.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.minio_gateway_nodes.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
    {
      rolearn  = module.repostore_nodes.iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    },
  ]

  depends_on = [aws_kms_key.eks]
}