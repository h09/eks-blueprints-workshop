{"filter":false,"title":"main.tf","tooltip":"/eks-blueprint/modules/eks_cluster/main.tf","undoManager":{"mark":6,"position":6,"stack":[[{"start":{"row":108,"column":0},"end":{"row":183,"column":0},"action":"insert","lines":["","data \"aws_iam_role\" \"eks_admin_role_name\" {","  count     = local.eks_admin_role_name != \"\" ? 1 : 0","  name = local.eks_admin_role_name","}","","module \"eks_blueprints_platform_teams\" {","  source  = \"aws-ia/eks-blueprints-teams/aws\"","  version = \"~> 0.2\"","","  name = \"team-platform\"","","  # Enables elevated, admin privileges for this team","  enable_admin = true"," ","  # Define who can impersonate the team-platform Role","  users             = [","    data.aws_caller_identity.current.arn,","    try(data.aws_iam_role.eks_admin_role_name[0].arn, data.aws_caller_identity.current.arn),","  ]","  cluster_arn       = module.eks.cluster_arn","  oidc_provider_arn = module.eks.oidc_provider_arn","","  labels = {","    \"elbv2.k8s.aws/pod-readiness-gate-inject\" = \"enabled\",","    \"appName\"                                 = \"platform-team-app\",","    \"projectName\"                             = \"project-platform\",","  }","","  annotations = {","    team = \"platform\"","  }","","  namespaces = {","    \"team-platform\" = {","","      resource_quota = {","        hard = {","          \"requests.cpu\"    = \"10000m\",","          \"requests.memory\" = \"20Gi\",","          \"limits.cpu\"      = \"20000m\",","          \"limits.memory\"   = \"50Gi\",","          \"pods\"            = \"20\",","          \"secrets\"         = \"20\",","          \"services\"        = \"20\"","        }","      }","","      limit_range = {","        limit = [","          {","            type = \"Pod\"","            max = {","              cpu    = \"1000m\"","              memory = \"1Gi\"","            },","            min = {","              cpu    = \"10m\"","              memory = \"4Mi\"","            }","          },","          {","            type = \"PersistentVolumeClaim\"","            min = {","              storage = \"24M\"","            }","          }","        ]","      }","    }","","  }","","  tags = local.tags","}",""],"id":2,"ignore":true}],[{"start":{"row":183,"column":0},"end":{"row":276,"column":0},"action":"insert","lines":["module \"eks_blueprints_dev_teams\" {","  source  = \"aws-ia/eks-blueprints-teams/aws\"","  version = \"~> 0.2\"","","  for_each = {","    burnham = {","      labels = {","        \"elbv2.k8s.aws/pod-readiness-gate-inject\" = \"enabled\",","        \"appName\"                                 = \"burnham-team-app\",","        \"projectName\"                             = \"project-burnham\",","      }","    }","    riker = {","      labels = {","        \"elbv2.k8s.aws/pod-readiness-gate-inject\" = \"enabled\",","        \"appName\"                                 = \"riker-team-app\",","        \"projectName\"                             = \"project-riker\",","      }","    }","  }","  name = \"team-${each.key}\"","","  users             = [data.aws_caller_identity.current.arn]","  cluster_arn       = module.eks.cluster_arn","  oidc_provider_arn = module.eks.oidc_provider_arn","","  labels = merge(","    {","      team = each.key","    },","    try(each.value.labels, {})","  )","","  annotations = {","    team = each.key","  }","","  namespaces = {","    \"team-${each.key}\" = {","      labels = merge(","        {","          team = each.key","        },","        try(each.value.labels, {})","      )","","      resource_quota = {","        hard = {","          \"requests.cpu\"    = \"100\",","          \"requests.memory\" = \"20Gi\",","          \"limits.cpu\"      = \"200\",","          \"limits.memory\"   = \"50Gi\",","          \"pods\"            = \"15\",","          \"secrets\"         = \"10\",","          \"services\"        = \"20\"","        }","      }","","      limit_range = {","        limit = [","          {","            type = \"Pod\"","            max = {","              cpu    = \"2\"","              memory = \"1Gi\"","            }","            min = {","              cpu    = \"10m\"","              memory = \"4Mi\"","            }","          },","          {","            type = \"PersistentVolumeClaim\"","            min = {","              storage = \"24M\"","            }","          },","          {","            type = \"Container\"","            default = {","              cpu    = \"50m\"","              memory = \"24Mi\"","            }","          }","        ]","      }","    }","  }","","  tags = local.tags","","}","",""],"id":3,"ignore":true}],[{"start":{"row":83,"column":4},"end":{"row":83,"column":5},"action":"remove","lines":["#"],"id":4,"ignore":true},{"start":{"row":84,"column":4},"end":{"row":84,"column":5},"action":"remove","lines":["#"]}],[{"start":{"row":276,"column":0},"end":{"row":329,"column":0},"action":"insert","lines":["module \"kubernetes_addons\" {","  source = \"github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.32.0/modules/kubernetes-addons\"","","  eks_cluster_id     = module.eks.cluster_name","","  #---------------------------------------------------------------","  # ARGO CD ADD-ON","  #---------------------------------------------------------------","","  enable_argocd         = true","  argocd_manage_add_ons = true # Indicates that ArgoCD is responsible for managing/deploying Add-ons.","","  argocd_applications = {","    addons    = local.addons_application","    #workloads = local.workload_application #We comment it for now","  }","","  argocd_helm_config = {","    set_sensitive = [","      {","        name  = \"configs.secret.argocdServerAdminPassword\"","        value = bcrypt(data.aws_secretsmanager_secret_version.admin_password_version.secret_string)","      }","    ]    ","    set = [","      {","        name  = \"server.service.type\"","        value = \"LoadBalancer\"","      }","    ]","  }","","  #---------------------------------------------------------------","  # EKS Managed AddOns","  # https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/","  #---------------------------------------------------------------","","  enable_amazon_eks_coredns = true","  enable_amazon_eks_kube_proxy = true","  enable_amazon_eks_vpc_cni = true      ","  enable_amazon_eks_aws_ebs_csi_driver = true","","  #---------------------------------------------------------------","  # ADD-ONS - You can add additional addons here","  # https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/","  #---------------------------------------------------------------","","","  enable_aws_load_balancer_controller  = true","  enable_aws_for_fluentbit             = true","  enable_metrics_server                = true","","}",""],"id":5,"ignore":true}],[{"start":{"row":277,"column":1},"end":{"row":277,"column":3},"action":"insert","lines":[" #"],"id":6,"ignore":true},{"start":{"row":277,"column":99},"end":{"row":278,"column":119},"action":"insert","lines":["","  source = \"github.com/aws-ia/terraform-aws-eks-blueprints?ref=blueprints-workshops/modules/kubernetes-addons\" ## <- 追加"]}],[{"start":{"row":291,"column":4},"end":{"row":291,"column":5},"action":"remove","lines":["#"],"id":7,"ignore":true}],[{"start":{"row":329,"column":0},"end":{"row":331,"column":0},"action":"insert","lines":["  enable_argo_rollouts                 = true","",""],"id":8,"ignore":true}]]},"ace":{"folds":[],"scrolltop":1248.0000000000005,"scrollleft":0,"selection":{"start":{"row":0,"column":0},"end":{"row":0,"column":0},"isBackwards":false},"options":{"guessTabSize":true,"useWrapMode":false,"wrapToView":true},"firstLineState":{"row":77,"state":"start","mode":"ace/mode/terraform"}},"timestamp":1690272747864,"hash":"f16f6a89a8d0e186ee1704fb9899f0200903e3e4"}