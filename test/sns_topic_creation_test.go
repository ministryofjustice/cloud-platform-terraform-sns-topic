package main

import (
	"regexp"
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

	assert.Regexp(t, regexp.MustCompile(`^arn:aws:sns:::cloud-platform-*`), snsArn)
	assert.Regexp(t, regexp.MustCompile(`^cloud-platform-*`), snsName)

}
