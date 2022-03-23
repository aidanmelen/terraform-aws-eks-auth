package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformCompleteExample(t *testing.T) {
	terraformOptions := &terraform.Options{
		// website::tag::1:: Set the path to the Terraform code that will be tested.
		TerraformDir: "../examples/complete",

		// Disable colors in Terraform commands so its easier to parse stdout/stderr
		NoColor: true,
	}

	// website::tag::4:: Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2:: Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables and check they have the expected values.
	outputManagedNodeGroupIamRoleArn := terraform.Output(t, terraformOptions, "managed_node_group_iam_role_arn")
	outputSelfManagedNodeGroupIamRoleArn := terraform.Output(t, terraformOptions, "self_managed_node_group_iam_role_arn")
	outputFargateProfilesIamRoleArn := terraform.Output(t, terraformOptions, "fargate_profile_iam_role_arn")
	outputMapRoles := terraform.OutputList(t, terraformOptions, "map_roles")
	outputMapUsers := terraform.OutputList(t, terraformOptions, "map_users")
	outputMapAccounts := terraform.OutputList(t, terraformOptions, "map_accounts")

	expectedMapRoles := []string([]string{
		"map[groups:[system:bootstrappers system:nodes] rolearn:" + outputManagedNodeGroupIamRoleArn + " username:system:node:{{EC2PrivateDNSName}}]",
		"map[groups:[system:bootstrappers system:nodes] rolearn:" + outputSelfManagedNodeGroupIamRoleArn + " username:system:node:{{EC2PrivateDNSName}}]",
		"map[groups:[system:bootstrappers system:nodes system:node-proxier] rolearn:" + outputFargateProfilesIamRoleArn + " username:system:node:{{SessionName}}]",
		"map[groups:[system:masters] rolearn:arn:aws:iam::66666666666:role/role1 username:role1]",
	})
	expectedMapUsers := []string([]string{
		"map[groups:[system:masters] userarn:arn:aws:iam::66666666666:user/user1 username:user1]",
		"map[groups:[system:masters] userarn:arn:aws:iam::66666666666:user/user2 username:user2]",
	})
	expectedMapAccounts := []string([]string{"777777777777", "888888888888"})

	assert.Equal(t, expectedMapRoles, outputMapRoles, "Map %q should match %q", expectedMapRoles, expectedMapRoles)
	assert.Equal(t, expectedMapUsers, outputMapUsers, "Map %q should match %q", expectedMapUsers, outputMapUsers)
	assert.Equal(t, expectedMapAccounts, outputMapAccounts, "Map %q should match %q", expectedMapAccounts, outputMapAccounts)

	// website::tag::4:: Run a second "terraform apply". Fail the test if results have changes
	terraform.ApplyAndIdempotent(t, terraformOptions)
}
