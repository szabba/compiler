module Stage.Desugar exposing (desugar)

import AST.Canonical as Canonical
import AST.Frontend as Frontend
import Common.Types exposing (Project)
import Error exposing (Error)


desugar : Project Frontend.Expr -> Result Error (Project Canonical.Expr)
desugar project =
    -- TODO for now, canonical AST is the same as frontend AST, so do nothing
    Ok project
