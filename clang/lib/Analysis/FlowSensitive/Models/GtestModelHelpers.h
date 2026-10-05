#include "clang/AST/Expr.h"
#include "clang/AST/ExprCXX.h"
#include "clang/ASTMatchers/ASTMatchers.h"
#include "clang/Analysis/FlowSensitive/DataflowEnvironment.h"
#include "clang/Analysis/FlowSensitive/StorageLocation.h"
#include <cassert>

namespace clang {
namespace dataflow {
namespace gtest {
void transferAssertionResultExpectationOperatorBoolCall(
    const CXXMemberCallExpr *Expr, Environment &Env,
    llvm::function_ref<StorageLocation &(RecordStorageLocation &)> GetOk);

clang::ast_matchers::StatementMatcher
isAssertionResultExpectationOperatorBoolCall();
} // namespace gtest
} // namespace dataflow
} // namespace clang
