# Learn Terraform Own Experiments

This repo started as an exercise for [Terraform Resource Targeting tutorial](https://developer.hashicorp.com/terraform/tutorials/state/resource-targeting), but because currently almost all Terraform tutorials are broken (due to S3 ACLs) and also I had some nagging questions I created this one.

- Due to S3 ACL issues almost all Terraform tutorials are broken - they are trying to set ACLs of buckets but those cannot be set by default anymore; trying to fix it by editing `Block Public Access` and changing the `Object Ownership` did not quite work - errors were still thrown that ACLs cannot be changed; however after re-applying those would eventually succeed - which inclined me to use some sort of time dealy to workaround the issue.
- I wanted to change a module to produce multiple sets of resources instead of just one, but wanted to keep the original resource (a bucket) - and did that by keeping the name and using `moved`
- Finally I wanted to generate some files and distribute those accross multiple buckets
