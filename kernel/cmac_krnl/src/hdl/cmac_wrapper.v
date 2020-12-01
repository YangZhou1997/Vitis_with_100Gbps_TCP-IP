`timescale 1 ns / 1 ps

module cmac_wrapper#(
  parameter integer C_S_AXI_CONTROL_ADDR_WIDTH = 12 ,
  parameter integer C_S_AXI_CONTROL_DATA_WIDTH = 32 ,
  parameter integer C_AXIS_NET_RX_TDATA_WIDTH  = 512,
  parameter integer C_AXIS_NET_TX_TDATA_WIDTH  = 512
)
(
  // System Signals
  input  wire                                    ap_clk               ,
  input  wire                                    ap_rst_n             ,
  // AXI4-Stream (master) interface axis_net_rx
  output wire                                    axis_net_rx_tvalid   ,
  input  wire                                    axis_net_rx_tready   ,
  output wire [C_AXIS_NET_RX_TDATA_WIDTH-1:0]    axis_net_rx_tdata    ,
  output wire [C_AXIS_NET_RX_TDATA_WIDTH/8-1:0]  axis_net_rx_tkeep    ,
  output wire                                    axis_net_rx_tlast    ,
  // AXI4-Stream (slave) interface axis_net_tx
  input  wire                                    axis_net_tx_tvalid   ,
  output wire                                    axis_net_tx_tready   ,
  input  wire [C_AXIS_NET_TX_TDATA_WIDTH-1:0]    axis_net_tx_tdata    ,
  input  wire [C_AXIS_NET_TX_TDATA_WIDTH/8-1:0]  axis_net_tx_tkeep    ,
  input  wire                                    axis_net_tx_tlast    ,
  // AXI4-Lite slave interface
  input  wire                                    s_axi_control_awvalid,
  output wire                                    s_axi_control_awready,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_awaddr ,
  input  wire                                    s_axi_control_wvalid ,
  output wire                                    s_axi_control_wready ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_wdata  ,
  input  wire [C_S_AXI_CONTROL_DATA_WIDTH/8-1:0] s_axi_control_wstrb  ,
  input  wire                                    s_axi_control_arvalid,
  output wire                                    s_axi_control_arready,
  input  wire [C_S_AXI_CONTROL_ADDR_WIDTH-1:0]   s_axi_control_araddr ,
  output wire                                    s_axi_control_rvalid ,
  input  wire                                    s_axi_control_rready ,
  output wire [C_S_AXI_CONTROL_DATA_WIDTH-1:0]   s_axi_control_rdata  ,
  output wire [2-1:0]                            s_axi_control_rresp  ,
  output wire                                    s_axi_control_bvalid ,
  input  wire                                    s_axi_control_bready ,
  output wire [2-1:0]                            s_axi_control_bresp  ,

  // Network physical
  input  wire clk_gt_freerun,
  input  wire [3:0] gt_rxp_in,
  input  wire [3:0] gt_rxn_in,
  output wire [3:0] gt_txp_out,
  output wire [3:0] gt_txn_out, 
  input  wire gt_refclk0_p,
  input  wire gt_refclk0_n 
);

cmac_krnl #(
.C_S_AXI_CONTROL_ADDR_WIDTH(C_S_AXI_CONTROL_ADDR_WIDTH),
.C_S_AXI_CONTROL_DATA_WIDTH(C_S_AXI_CONTROL_DATA_WIDTH),
.C_AXIS_NET_RX_TDATA_WIDTH (C_AXIS_NET_RX_TDATA_WIDTH ),
.C_AXIS_NET_TX_TDATA_WIDTH (C_AXIS_NET_TX_TDATA_WIDTH )
)
(
.ap_clk               (ap_clk               ),
.ap_rst_n             (ap_rst_n             ),
.axis_net_rx_tvalid   (axis_net_rx_tvalid   ),
.axis_net_rx_tready   (axis_net_rx_tready   ),
.axis_net_rx_tdata    (axis_net_rx_tdata    ),
.axis_net_rx_tkeep    (axis_net_rx_tkeep    ),
.axis_net_rx_tlast    (axis_net_rx_tlast    ),
.axis_net_tx_tvalid   (axis_net_tx_tvalid   ),
.axis_net_tx_tready   (axis_net_tx_tready   ),
.axis_net_tx_tdata    (axis_net_tx_tdata    ),
.axis_net_tx_tkeep    (axis_net_tx_tkeep    ),
.axis_net_tx_tlast    (axis_net_tx_tlast    ),
.s_axi_control_awvalid(s_axi_control_awvalid),
.s_axi_control_awready(s_axi_control_awready),
.s_axi_control_awaddr (s_axi_control_awaddr ),
.s_axi_control_wvalid (s_axi_control_wvalid ),
.s_axi_control_wready (s_axi_control_wready ),
.s_axi_control_wdata  (s_axi_control_wdata  ),
.s_axi_control_wstrb  (s_axi_control_wstrb  ),
.s_axi_control_arvalid(s_axi_control_arvalid),
.s_axi_control_arready(s_axi_control_arready),
.s_axi_control_araddr (s_axi_control_araddr ),
.s_axi_control_rvalid (s_axi_control_rvalid ),
.s_axi_control_rready (s_axi_control_rready ),
.s_axi_control_rdata  (s_axi_control_rdata  ),
.s_axi_control_rresp  (s_axi_control_rresp  ),
.s_axi_control_bvalid (s_axi_control_bvalid ),
.s_axi_control_bready (s_axi_control_bready ),
.s_axi_control_bresp  (s_axi_control_bresp  )
);
    
endmodule