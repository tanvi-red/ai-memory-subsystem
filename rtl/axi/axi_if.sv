cat << 'EOF' > rtl/axi/axi_if.sv
interface axi_if #(
    parameter int ADDR_WIDTH = 40,
    parameter int DATA_WIDTH = 128,
    parameter int ID_WIDTH   = 4
)(
    input logic clk,
    input logic rst_n
);

    // ----------------------------------------------------
    // 1. Write Address Channel (AW)
    // ----------------------------------------------------
    logic [ID_WIDTH-1:0]   awid;
    logic [ADDR_WIDTH-1:0] awaddr;
    logic [7:0]            awlen;
    logic [2:0]            awsize;
    logic [1:0]            awburst;
    logic                  awvalid;
    logic                  awready;

    // ----------------------------------------------------
    // 2. Write Data Channel (W)
    // ----------------------------------------------------
    logic [DATA_WIDTH-1:0]     wdata;
    logic [(DATA_WIDTH/8)-1:0] wstrb;
    logic                      wlast;
    logic                      wvalid;
    logic                      wready;

    // ----------------------------------------------------
    // 3. Write Response Channel (B)
    // ----------------------------------------------------
    logic [ID_WIDTH-1:0]   bid;
    logic [1:0]            bresp;
    logic                  bvalid;
    logic                  bready;

    // ----------------------------------------------------
    // 4. Read Address Channel (AR)
    // ----------------------------------------------------
    logic [ID_WIDTH-1:0]   arid;
    logic [ADDR_WIDTH-1:0] araddr;
    logic [7:0]            arlen;
    logic [2:0]            arsize;
    logic [1:0]            arburst;
    logic                  arvalid;
    logic                  arready;

    // ----------------------------------------------------
    // 5. Read Data Channel (R)
    // ----------------------------------------------------
    logic [ID_WIDTH-1:0]   rid;
    logic [DATA_WIDTH-1:0] rdata;
    logic [1:0]            rresp;
    logic                  rlast;
    logic                  rvalid;
    logic                  rready;

    // Modport for Master components (e.g., AI Accelerator / DMA)
    modport master (
        output awid, awaddr, awlen, awsize, awburst, awvalid,
        input  awready,
        output wdata, wstrb, wlast, wvalid,
        input  wready,
        input  bid, bresp, bvalid,
        output bready,
        output arid, araddr, arlen, arsize, arburst, arvalid,
        input  arready,
        input  rid, rdata, rresp, rlast, rvalid,
        output rready
    );

    // Modport for Slave components (e.g., Interconnect / Memory Controller)
    modport slave (
        input  awid, awaddr, awlen, awsize, awburst, awvalid,
        output awready,
        input  wdata, wstrb, wlast, wvalid,
        output wready,
        output bid, bresp, bvalid,
        input  bready,
        input  arid, araddr, arlen, arsize, arburst, arvalid,
        output arready,
        output rid, rdata, rresp, rlast, rvalid,
        input  rready
    );

endinterface
EOF