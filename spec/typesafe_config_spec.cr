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

it "should properly propagate java properties" do
  cmd = "sh"
  args = ["-c", %(export CONFIG_ciao=pippo && java $(bin/env2props -p CONFIG_) spec.CheckProperties)]
  exit_value, output = run_cmd(cmd, args)

  output.includes?("ciao").should eq(true)
  output.includes?("pippo").should eq(true)
  exit_value.should eq(0)
end
