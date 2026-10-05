add_clang_library(clangAnalysisFlowSensitiveModels
  ChromiumCheckModel.cpp
  UncheckedOptionalAccessModel.cpp
  UncheckedStatusOrAccessModel.cpp
  GtestModelHelpers.cpp
  GtestModelHelpers.h

  LINK_LIBS
  clangAnalysis
  clangAnalysisFlowSensitive
  clangAST
  clangASTMatchers
  clangBasic
  )
