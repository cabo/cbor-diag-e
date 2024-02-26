require 'cbor-diagnostic-parser'
require 'shellwords'
require 'open3'
require 'yaml'

class CBOR_DIAG::App_e
  CBOR_DIAG_CDDL_NAME = ENV["CBOR_DIAG_CDDL"]
  raise "e'...': No CBOR_DIAG_CDDL given" unless CBOR_DIAG_CDDL_NAME

  cddlcs, status = Open3.capture2("cddlc -2tconst #{Shellwords.escape(CBOR_DIAG_CDDL_NAME)}")
  raise "e'...': cannot run cddlc" unless status.success?
  CONSTS_MAP = YAML.load(cddlcs)

  def self.decode(_, s)
    CONSTS_MAP.fetch(s) do
      construct = "e'#{s}'"
      warn "*** e'...': No external constant value defined for #{construct}"
      construct
    end
  end
end
