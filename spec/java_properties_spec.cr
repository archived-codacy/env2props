require "spec"

def run_cmd(cmd, args)
  stdout = IO::Memory.new
  stderr = IO::Memory.new
  status = Process.run(cmd, args: args, shell: true, output: stdout, error: stderr)
  if status.success?
    {status.exit_code, stdout.to_s}
  else
    {status.exit_code, stderr.to_s}
  end
end

cmd = "sh"

it "should properly propagate simple java properties" do
  args = ["-c", %(export CONFIG_mykey=myvalue && java "$(bin/env2props -p CONFIG_)" spec.CheckProperties)]
  exit_value, output = run_cmd(cmd, args)

  output.includes?("mykey:myvalue").should eq(true)
  exit_value.should eq(0)
end

it "should properly propagate escaped multi string java properties" do
  args = ["-c", %(export CONFIG_mykey="my value" && java "$(bin/env2props -p CONFIG_)" spec.CheckProperties)]
  exit_value, output = run_cmd(cmd, args)

  output.includes?("mykey:\"my value\"").should eq(true)
  exit_value.should eq(0)
end
