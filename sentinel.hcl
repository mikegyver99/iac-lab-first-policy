policy "first policy pmr" {
  source            = "./require-modules-from-pmr.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "enforce tags" {
  source            = "./enforce-mandatory-tags.sentinel"
  enforcement_level = "hard-mandatory"
}
