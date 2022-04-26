/*
 * Contract language
 * Meant for use with ANTLR.
 *
 * Built up by Maxim Menshikov.
 */
grammar Contract;

import C;

// Edit to get rid of dependency upon ANTLR C++ target.
@parser::preinclude {
    #include "CParser.h"
}

@lexer::members {
  bool skipCommentSymbols;
}

id
    : Identifier
    ;

string
    : StringLiteral+
    ;

// term.tex
literal
    : 'true'                                            # true_constant
    | 'false'                                           # false_constant
    | Constant                                          # trivial_constant
    | string                                            # string_constant
    ;

bin_op
    : '+' | '-' | '*' | '/' | '%' | '<<' | '>>'
    | '==' | '!=' | '<=' | '>=' | '>' | '<'
    | '&&' | '||' | '^^'
    | '&' | '|' | '-->' | '<-->' | '^'
    ;

unary_op
    : '+'
    | '-'
    | '!'
    | '*'
    | '&'
    ;

term
    : literal                                           # literal_term
    | poly_id                                           # variable_term
    | typeName                                          # typename_term
    | unary_op term                                     # unary_op_term
    | term bin_op term                                  # binary_op_term
    | term '[' term ']'                                 # array_access_term
    | term '.' id                                       # structure_field_access_term
    | '{' term '\\with' '.' id '=' term '}'             # field_func_modifier_term
    | term '->' id                                      # pointer_structure_field_access_term
    | poly_id '(' term (',' term)* ')'                  # func_application_term
    | '(' term ')'                                      # parentheses_term
    | term '?' term ':' term                            # ternary_cond_term
    | 'sizeof' '(' term ')'                             # sizeof_term
    | '@result'                                         # result_term
    | 'NULL'                                            # null_term
    | 'length' '(' term ')'                             # length_term
    ;

poly_id
    : Identifier
    ;

rel_op
    : '=='
    | '!='
    | '<='
    | '>='
    | '>'
    | '<'
    ;

pred
    : 'true'                            # logical_true_pred
    | 'false'                           # logical_false_pred
    | term (rel_op term)+               # comparison_pred
    | ident '(' term (',' term)* ')'    # predicate_application_pred
    | '(' pred ')'                      # parentheses_pred
    | pred '&&' pred                    # conjunction_pred
    | pred '||' pred                    # disjunction_pred
    | pred '==>' pred                   # implication_pred
    | pred '<==>' pred                  # equivalence_pred
    | '!' pred                          # negation_pred
    | pred '^^' pred                    # exclusive_or_pred
    | term '?' pred ':' pred            # ternary_condition_term_pred
    | pred '?' pred ':' pred            # ternary_condition_pred
    | pred 'report' 'as' string         # report_pred
    ;

ident
    : id
    ;

tset
    : '@empty'                          # tset_empty
    | tset '->' id                      # tset_pointer_access
    | tset '.' id                       # tset_member_access
    | '*' tset                          # tset_deref
    | '&' tset                          # tset_addr
    | tset '[' tset ']'                 # tset_array_access
    | tset '+' tset                     # tset_plus
    | '(' tset ')'                      # tset_paren
    | term                              # tset_term
    ;

// String list
strings
    : string (',' string)*
    ;

// Locations
location
    : tset
    ;

locations
    : location (',' location)*
    ;

// Main clauses
assume_clause
    : 'assume' pred ';'
    ;
require_clause
    : 'require' pred ';'
    ;

ensure_clause
    : 'ensure' pred ';'
    ;

assign_clause
    : 'assign' locations ';'
    ;

any_clause
    : require_clause
    | assign_clause
    | ensure_clause
    | assume_clause
    ;

// Contract body
contract_body
    : any_clause+
    ;

// Named behaviors
named_behavior
    : 'behavior' id ':' contract_body
    ;

named_behaviors
    : named_behavior+
    ;

function_contract
    : contract_body
    | named_behaviors
    ;
