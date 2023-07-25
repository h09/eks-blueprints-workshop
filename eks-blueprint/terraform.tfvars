aws_region          = "us-west-2"
environment_name     = "eks-blueprint"

eks_admin_role_name = "WSParticipantRole"

addons_repo_url = "https://github.com/aws-samples/eks-blueprints-add-ons.git"

workload_repo_url = "https://github.com/h09/eks-blueprints-workloads.git"
workload_repo_revision = "main"
workload_repo_path     = "envs/dev"
