module Stage.Parse exposing (parse)

import AST.Common exposing (TopLevelDeclaration, VarName)
import AST.Frontend as Frontend
import Common
import Common.Types
    exposing
        ( Dict_
        , FileContents(..)
        , FilePath(..)
        , Module
        , ModuleName
        , Project
        , Set_
        )
import Error exposing (Error(..), ParseError(..))
import Parser.Advanced as P
import Stage.Parse.Parser as Parser


parse : Project a -> FilePath -> FileContents -> Result Error (Module Frontend.Expr)
parse { sourceDirectory } filePath (FileContents fileContents) =
    P.run (Parser.module_ filePath) fileContents
        |> Result.mapError (ParseError << ParseProblem)
        |> Result.andThen (checkModuleNameAndFilePath sourceDirectory filePath)


checkModuleNameAndFilePath : FilePath -> FilePath -> Module Frontend.Expr -> Result Error (Module Frontend.Expr)
checkModuleNameAndFilePath sourceDirectory filePath ({ name } as parsedModule) =
    let
        expectedName : Result Error ModuleName
        expectedName =
            Common.expectedModuleName sourceDirectory filePath
    in
    if expectedName == Ok name then
        Ok parsedModule

    else
        ModuleNameDoesntMatchFilePath name filePath
            |> ParseError
            |> Err
