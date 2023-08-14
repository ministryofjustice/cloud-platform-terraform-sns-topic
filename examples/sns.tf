/*
 * Make sure that you use the latest version of the module by changing the
 * `ref=` value in the `source` attribute to the latest version listed on the
 * releases page of this repository.
 *
 */
module "example_sns_topic" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sns-topic?ref=4.9.0"

  topic_display_name     = "example-topic-display-name"
  business_unit          = "example"
  application            = "example"
  is_production          = "false"
  team_name              = "example-team"
  environment_name       = "example"
  infrastructure_support = "example"
  namespace              = "example"

  # Uncomment additional_topic_clients and populate list for provisioning additional IAM user/access keys for topic access
  # via other namespaces - see kubernetes_secret examples below
  #
  # additional_topic_clients = [ "team-1","team-2" ]
}

resource "kubernetes_secret" "example_sns_topic" {
  metadata {
    name      = "my-topic-sns-user"
    namespace = "example_namespace"
  }

  data = {
    access_key_id     = module.example_sns_topic.access_key_id
    secret_access_key = module.example_sns_topic.secret_access_key
    topic_arn         = module.example_sns_topic.topic_arn
  }
}

# Example for pushing additional user/access key secrets into namespaces
#
# resource "kubernetes_secret" "team_1_secret" {
#   metadata {
#     name      = "sns-topic-sns-user"
#     namespace = "another-namespace"
#   }

#   data = {
#     access_key_id     = module.sw_sns.additional_access_keys["team-1"].access_key_id
#     secret_access_key = module.sw_sns.additional_access_keys["team-1"].secret_access_key
#     topic_arn         = module.sw_sns.topic_arn
#   }
# }

# Or, define your additional_topic_clients as target namespace strings and iterate over the list with a single kubernetes secret:
#
# resource "kubernetes_secret" "additional_secrets" {
#   for_each = toset(var.additional_topic_clients)
#   metadata {
#     name      = "sns-topic-sns-client-${each.value}"
#     namespace = each.value
#   }

#   data = {
#     access_key_id     = module.sw_sns.additional_access_keys[each.value].access_key_id
#     secret_access_key = module.sw_sns.additional_access_keys[each.value].secret_access_key
#     topic_arn         = module.sw_sns.topic_arn
#   }
# }