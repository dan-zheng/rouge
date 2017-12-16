# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class DLVM < RegexLexer
      title "DLVM"
      desc 'The DLVM Compiler Infrastructure (http://dlvm.org/)'
      tag 'dlvm'

      filenames '*.dl'
      mimetypes 'text/x-dlvm'

      string = /"[^"]*?"/
      identifier = /([-a-zA-Z$._][-a-zA-Z$._0-9]*|#{string})/
      use = /(%[0-9][1-9]*.[0-9][1-9]*)/
      id = /(%#{identifier}|#{use})/

      state :basic do
        rule %r(\/\/.*?$), Comment::Single
        rule /\s+/, Text

        rule /@#{identifier}/, Name::Function
        rule /'#{identifier}\s*(?=[(])/, Name::Label
        rule /#{id}\s*/, Name::Variable

        rule /c?#{string}/, Str

        rule /0[xX][a-fA-F0-9]+/, Num
        rule /-?\d+(?:[.]\d+)?(?:[eE][-+]?\d+(?:[.]\d+)?)?/, Num

        rule /[={}\[\]()*:.,]/, Punctuation
        rule %r(->|[-/=+*%!&|^.~•⨂]+), Operator
        rule /[<>x]/, Keyword::Declaration
      end

      builtin_types = %w(
        f16 f32 f64 bool
      )

      state :types do
        rule /i[1-9]\d*/, Keyword::Type
        rule /#{builtin_types.join('|')}/, Keyword::Type
      end

      builtin_keywords = %w(
        module stage raw optimizable compute scheduled canonical struct func var
        type opaque at to from by upto then else wrt keeping void zero undefined
        null true false scalar count seedable extern gradient init along
      )

      builtin_instructions = %w(
        literal branch conditional return dataTypeCast scan reduce dot matrixMultiply
        concatenate transpose slice shapeCast bitCast extract insert apply allocateStack
        allocateHeap allocateBox projectBox retain release deallocate load store
        elementPointer copy trap random select lessThan lessThanOrEqual greaterThan
        greaterThanOrEqual equal notEqual and or add subtract multiply divide min max
        truncateDivide floorDivide modulo power mean sinh cosh tanh log exp negate
        sign square sqrt round rsqrt ceil floor tan cos sin acos asin atan lgamma
        digamma erf erfc rint not
      )

      state :keywords do
        rule /#{builtin_instructions.join('|')}/, Keyword
        rule /#{builtin_keywords.join('|')}/, Keyword::Reserved
      end

      state :root do
        mixin :basic
        mixin :keywords
        mixin :types
      end
    end
  end
end
