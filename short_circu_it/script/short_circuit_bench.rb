# frozen_string_literal: true

require "benchmark"
require_relative "../lib/short_circu_it"

class A
  include ShortCircuIt

  def ivar_no_args
    @ivar ||= rand
  end

  def sc_no_args
    rand
  end
  memoize :sc_no_args

  def sc_no_args_observes_nil
    rand
  end
  memoize :sc_no_args_observes_nil, observes: nil

  def ivar_one_arg(a)
    @ivar_one_arg ||= {}
    @ivar_one_arg[a] ||= rand
  end

  def sc_one_arg(a)
    rand
  end
  memoize :sc_one_arg

  def sc_one_arg_observes_nil(a)
    rand
  end
  memoize :sc_one_arg_observes_nil, observes: nil
end

n = 10000
a = A.new

Benchmark.bm do |b|
  b.report("ivar no arg") { n.times { a.ivar_no_args } }
  b.report("sc no arg") { n.times { a.sc_no_args } }
  b.report("sc no arg obs nil") { n.times { a.sc_no_args_observes_nil } }

  b.report("ivar one arg") { n.times { a.ivar_one_arg([1, 2].sample) } }
  b.report("sc one arg") { n.times { a.sc_one_arg([1, 2].sample) } }
  b.report("sc one arg obs nil") { n.times { a.sc_one_arg_observes_nil([1, 2].sample) } }
end
