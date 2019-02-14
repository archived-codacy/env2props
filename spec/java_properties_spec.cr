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

CMD          = "sh"
DEFAULT_ARGS = ["-c"]

it "should properly propagate simple java properties" do
  args = DEFAULT_ARGS.clone
  args << %(export CONFIG_mykey1=myvalue && java $(bin/env2props -p CONFIG_) spec.CheckProperties)
  exit_value, output = run_cmd(CMD, args)

  output.includes?("mykey1:myvalue").should eq(true)
  exit_value.should eq(0)
end

it "should properly propagate escaped multi string java properties" do
  args = DEFAULT_ARGS.clone
  args << %(export CONFIG_mykey2="my value" && sh -c "java $(bin/env2props -p CONFIG_) spec.CheckProperties")
  exit_value, output = run_cmd(CMD, args)

  output.includes?("mykey2:my value").should eq(true)
  exit_value.should eq(0)
end

it "should properly inject multiple java properties" do
  args = DEFAULT_ARGS.clone
  args << %(export CONFIG_mykey11=1 && export CONFIG_mykey22=2 && java $(bin/env2props -p CONFIG_) spec.CheckProperties)
  exit_value, output = run_cmd(CMD, args)

  output.includes?("mykey11:1").should eq(true)
  output.includes?("mykey22:2").should eq(true)
  exit_value.should eq(0)
end

it "should get unquoted strings when using Typesafe config" do
  args = DEFAULT_ARGS.clone
  args << %(export CONFIG_mykey="1 2 3" && java "$(bin/env2props -p CONFIG_)" -cp config-1.3.2.jar:. spec.CheckTypesafeConfig)
  exit_value, output = run_cmd(CMD, args)

  output.includes?("1 2 3").should eq(true)
  exit_value.should eq(0)
end
