package main

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestSNSCreation(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./unit-test",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	snsArn := terraform.Output(t, terraformOptions, "sns_arn")
	snsName := terraform.Output(t, terraformOptions, "sns_name")

	assert.Equal(t, "arn:aws:sns:eu-west-2:000000000000:cloud-platform-development-unit-test", snsArn)
	assert.Equal(t, "cloud-platform-development-unit-test", snsName)

}
