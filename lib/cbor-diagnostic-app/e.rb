require 'cbor-diagnostic-parser'
require 'shellwords'
require 'open3'
require 'yaml'

class CBOR_DIAG::App_e
  CBOR_DIAG_CDDL_NAME = ENV["CBOR_DIAG_CDDL"]

  def self.consts_map(s)
    @cached_consts_map ||= (
      raise "e'#{s}': No CBOR_DIAG_CDDL file name given in environment" unless CBOR_DIAG_CDDL_NAME

      cddlcs, status = Open3.capture2("cddlc -2tconst #{Shellwords.escape(CBOR_DIAG_CDDL_NAME)}")
      raise "e'#{s}': Cannot run cddlc on #{CBOR_DIAG_CDDL_NAME.inspect}" unless status.success?
      YAML.load(cddlcs)
    )
  end

  def self.decode(_, s)
    consts_map(s).fetch(s) do
      construct = "e'#{s}'"
      warn "*** #{construct}: No external constant value defined in #{CBOR_DIAG_CDDL_NAME.inspect}"
      construct
    end
  end
end
