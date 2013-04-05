#!/usr/bin/env ruby

require 'minitest/autorun'

class TestOncein < MiniTest::Unit::TestCase
  def test_first_call_runs_command_with_no_delay
    key = generate_random_string
    
    t = time_taken_to do 
      assert_equal execute(4, "echo -n #{key}"), key
    end
    assert(t < 2)
  end

  def test_multiple_calls_delay_and_only_run_once
    key = generate_random_string
    execute(4, "echo -n #{key}")
    
    results = []
    threads = (0..20).to_a.map do
      Thread.new { results << execute(4, "echo -n #{key}") }  
    end
    
    t = time_taken_to { threads.each(&:join) }
    assert(t > 2)
    
    assert_equal 1, results.grep(key).count
  end

  def test_multiple_spaced_out_calls_do_not_delay
    key = generate_random_string
    execute(4, "echo -n #{key}")
    
    sleep 4
    
    t = time_taken_to do 
      assert_equal execute(4, "echo -n #{key}"), key
    end
    assert(t < 2)
  end  
  
private
  def execute(secs, cmd)
    result = `./oncein.sh #{secs} #{cmd} 2>&1`
    assert_equal 0, $?.to_i
    result
  end
  
  def generate_random_string
    "#{Time.now.to_f}#{$$}#{rand}"
  end
  
  def time_taken_to
    start = Time.now.to_f
    yield
    Time.now.to_f - start
  end
end

