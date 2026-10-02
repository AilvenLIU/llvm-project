// RUN: mlir-opt %s --transform-interpreter --verify-diagnostics

// `transform.test_fold` folds each test op with `Operation::fold` and reports
// the result as a remark. The test ops fold as their attributes say; see
// `getConfiguredLegacyFoldResults`.

// `test.fold_dispatch_fallback` has no fold and no fold trait, so only the
// fallback fold of the test dialect can fold it.
func.func @dialect_fallback(%arg0: i32) {
  // expected-remark @below {{fold: failure}}
  %0:2 = "test.fold_dispatch_fallback"() : () -> (i32, i32)
  // expected-remark @below {{fold: [1 : i32, 2 : i32]}}
  %1:2 = "test.fold_dispatch_fallback"() {dialect_fold = [1 : i32, 2 : i32]}
      : () -> (i32, i32)
  // expected-remark @below {{fold: in place}}
  %2:2 = "test.fold_dispatch_fallback"() {dialect_fold_in_place_count = 1}
      : () -> (i32, i32)
  // The result of the fallback is normalized, so the results of the op keep
  // the results.
  // expected-remark @below {{fold: failure}}
  %3:2 = "test.fold_dispatch_fallback"() {dialect_fold = ["result:0", "result:1"]}
      : () -> (i32, i32)
  // The fallback gets the constant operands.
  %c7 = "test.constant"() <{value = 7 : i32}> : () -> i32
  // expected-remark @below {{fold: [7 : i32, operand 1]}}
  %4:2 = "test.fold_dispatch_fallback"(%c7, %arg0)
      {dialect_fold = ["operand_attr:0", "operand:1"]} : (i32, i32) -> (i32, i32)
  return
}

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %ops = transform.structured.match
        ops{["test.fold_dispatch_fallback"]} in %root
        : (!transform.any_op) -> !transform.any_op
    transform.test_fold %ops : !transform.any_op
    transform.yield
  }
}
