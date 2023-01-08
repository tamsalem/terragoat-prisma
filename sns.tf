resource "aws_sns_topic" "sns_topic_notify" {	
  name = "testing-${var.stage}"
}	

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.sns_topic_notify.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.sns_topic_notify.arn]
    sid = "AWSEvents_${aws_sns_topic.sns_topic_notify.arn}_Id"
  }

statement {	
  	effect = "Allow"	
    actions = [	
      "SNS:Subscribe",	
      "SNS:SetTopicAttributes",	
      "SNS:RemovePermission",	
      "SNS:Receive",	
      "SNS:Publish",	
      "SNS:ListSubscriptionsByTopic",	
      "SNS:GetTopicAttributes",	
      "SNS:DeleteTopic",	
      "SNS:AddPermission",	
    ]	

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    principals {	
      type        = "AWS"	
      identifiers = ["*"]	
    }	

    resources = [	
      aws_sns_topic.sns_topic_notify.arn,	
    ]	
    sid = "__default_statement_ID"	
  }
}
