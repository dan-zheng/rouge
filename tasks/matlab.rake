# -*- coding: utf-8 -*- #

require 'open-uri'

def matlab_builtins(&b)
  return enum_for :matlab_builtins unless block_given?

  matlab_doc_url = 'http://www.mathworks.com/help/matlab/functionlist.html'

  matlab_docs = open(matlab_doc_url).read

  p :docs => matlab_docs

  matlab_docs.scan %r(<a href="[.][.]/matlab/ref/(\w+)[.]html">)m do |word|
    p :word => word
    yield word
  end
end

def matlab_builtins_source
  yield   "# -*- coding: utf-8 -*- #"
  yield   "# frozen_string_literal: true"
  yield   ""
  yield   "# automatically generated by `rake builtins:matlab`"
  yield   "module Rouge"
  yield   "  module Lexers"
  yield   "    class Matlab"
  yield   "      def self.builtins"
  yield   "        @builtins ||= Set.new %w(#{matlab_builtins.to_a.join(' ')})"
  yield   "      end"
  yield   "    end"
  yield   "  end"
  yield   "end"
end

namespace :builtins do
  task :matlab do
    File.open('lib/rouge/lexers/matlab/builtins.rb', 'w') do |f|
      matlab_builtins_source do |line|
        f.puts line
      end
    end
  end
end
