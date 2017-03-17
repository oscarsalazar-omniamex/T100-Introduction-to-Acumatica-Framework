﻿<%@ Page Language="C#" MasterPageFile="~/MasterPages/FormDetail.master" AutoEventWireup="true"
	ValidateRequest="false" CodeFile="SM208010.aspx.cs" Inherits="Page_SM208010" Title="Untitled Page" %>

<%@ MasterType VirtualPath="~/MasterPages/FormDetail.master" %>

<asp:Content ID="cont1" ContentPlaceHolderID="phDS" runat="Server">
	<style type="text/css">
		.GridMain .GridRow:hover
		{
			background-color: #e0e0e0;
			cursor:pointer;
		}
	</style>
	<script type="text/javascript">
		function commandResult(ds, context)
		{
			if (context.command == "Save" || context.command == "Delete")
			{
				var ds = px_all[context.id];
				var isSitemapAltered = (ds.callbackResultArg == "RefreshSitemap");
				if (isSitemapAltered) __refreshMainMenu();
			}
		}
	</script>

	<px:PXDataSource ID="ds" runat="server" Visible="True" PrimaryView="Tables" 
		TypeName="PX.Olap.Maintenance.PivotMaint">
        <ClientEvents CommandPerformed="commandResult" />
		<CallbackCommands>
			<px:PXDSCallbackCommand Name="AddFact" Visible="False"/>
			<px:PXDSCallbackCommand Name="AddInactive" Visible="False"/>
			<px:PXDSCallbackCommand Name="AddXDimension" Visible="False"/>
			<px:PXDSCallbackCommand Name="AddYDimension" Visible="False"/>
		</CallbackCommands>	
		<DataTrees>
			<px:PXTreeDataMember TreeView="SiteMapTree" TreeKeys="NodeID" />
            <px:PXTreeDataMember TreeView="DataScreenSiteMapTree" TreeKeys="NodeID" />
		</DataTrees>
		<ClientEvents Initialize="dataSource_Initialize" />
	</px:PXDataSource>
</asp:Content>

<asp:Content ID="cont2" ContentPlaceHolderID="phF" runat="Server">
	<px:PXFormView ID="form" runat="server" Width="100%" DataMember="Tables" OnDataBound="form_DataBound">
		<Template>
			<px:PXLayoutRule runat="server" StartRow="True" LabelsWidth="SM" ControlSize="M" Merge="true" />
				<px:PXTreeSelector ID="edScreenID" runat="server" DataField="ScreenID" PopulateOnDemand="False" AutoRefresh="True"
					ShowRootNode="False" TreeDataSourceID="ds" TreeDataMember="DataScreenSiteMapTree" MinDropWidth="413" CommitChanges="true">
					<DataBindings>
						<px:PXTreeItemBinding DataMember="DataScreenSiteMapTree" TextField="Title" ValueField="ScreenID" ImageUrlField="Icon" ToolTipField="TitleWithPath" />
					</DataBindings>
				</px:PXTreeSelector>
		        <px:PXDropDown ID="edFilterID" runat="server" DataField="FilterID" AllowNull="False" />
                <px:PXTreeSelector ID="edScreen" runat="server" DataField="SitemapParent" PopulateOnDemand="True" 
				    ShowRootNode="False" TreeDataSourceID="ds" TreeDataMember="SiteMapTree" MinDropWidth="413" CommitChanges="true">
				    <DataBindings>
					    <px:PXTreeItemBinding DataMember="SiteMapTree" TextField="Title" ValueField="NodeID" ImageUrlField="Icon" ToolTipField="TitleWithPath" />
				    </DataBindings>
				    <AutoCallBack Command="Save" Target="form" />
			    </px:PXTreeSelector>
            
			<px:PXLayoutRule runat="server" StartRow="True" LabelsWidth="SM" ControlSize="M" Merge="true" />
                <px:PXSelector ID="edPivotTableID" runat="server" DataField="PivotTableID" DataSourceID="ds" AutoRefresh="True" 
					NullText="<NEW>" DisplayMode="Text">
					<Parameters>
						<px:PXControlParam Name="PivotTable.screenID" ControlID="form" PropertyName="DataControls[&quot;edScreenID&quot;].Value" Type="String" Size="8" />
					</Parameters>
				</px:PXSelector>
				<px:PXTextEdit ID="edName" runat="server" DataField="Name" CommitChanges="True" />
		        <px:PXCheckBox ID="chkIsShared" runat="server" DataField="OwnerName" CommitChanges="True" />
		</Template>
			<Parameters>
				<px:PXControlParam ControlID="form" Name="PivotTable.screenID" PropertyName="NewDataKey[&quot;ScreenID&quot;]" Type="String" />
			</Parameters>
	</px:PXFormView>
</asp:Content>

<asp:Content ID="cont3" ContentPlaceHolderID="phG" runat="Server">
	<script type="text/javascript">

		var dimensionGrids = ["gridFacts", "gridInact", "gridXDim", "gridYDim"];

		function dataSource_Initialize(ds, ev)
		{
			for (var i = 0; i < dimensionGrids.length; i++)
			{
				var gr = px_alls[dimensionGrids[i]];
				if (gr) gr.suppressInitPosition = true;
			}

			var grp = px_alls["gridProps"];
			if (grp)
			{
			    grp.events.addEventHandler("startCellEdit", (s1, ev1) =>
			    {
			        ev1.cell.editor.control.events.addEventHandler("valueChanged", (s2, ev2) => grp.commitChanges());
			    });
			}
		}

		function grid_afterRowChange(grid, ev)
		{
			var propsGrid = px_alls["gridProps"];
			if (propsGrid && ev.keyChanged) propsGrid.refresh();
		}

		function grid_cellClick(grid, ev)
		{
			for (var i = 0; i < dimensionGrids.length; i++)
			{
				var gr = px_alls[dimensionGrids[i]];
				if (gr && gr != grid)
				{
					gr.resetPosition(); gr.resetPositionState();
					delete gr.lastDataKey;
				}
			}
		}

		function grid_DragDrop(grid, ev)
		{
			var params = ev.data.split('|'), gridF = px_all[params[0]];
			var dragRow = gridF.rows.getRow(params[1]), command;

			switch (grid.serverID)
			{
				case "gridInact": command = "AddInactive"; break;
				case "gridXDim": command = "AddXDimension"; break;
				case "gridYDim": command = "AddYDimension"; break;
				case "gridFacts": command = "AddFact"; break;
				case "gridFields": dragRow.removeRow(); return;
			}

			if (command && dragRow)
			{
				var isFields = (gridF == px_alls["gridFields"]);
				var displayName = dragRow.getCell(isFields ? "DisplayName" : "Caption").getValue();
				var name = dragRow.getCell(isFields ? "Name" : "Expression").getValue();

				if (name)
				{
					var args = [name, displayName];
					if (ev.targetRow)
					{
						var cell = ev.targetRow.getCell("Expression");
						if (cell) args.push(cell.getValue());
					}
					px_alls['ds'].executeCommand(command, args.join('|'));
				}
			}
		}

	</script>
	<px:PXSplitContainer runat="server" ID="sp1" SplitterPosition="220" Height="300px" >
		<AutoSize Enabled="true" Container="Window" />
		<Template1>
			<px:PXGrid ID="gridFields" runat="server" SkinID="Details" Width="100%" DataSourceID="ds" Height="200px" 
				CaptionVisible="true" Caption="Fields" AutoAdjustColumns="true" SyncPosition="true" AllowPaging="false" AllowDrop="true">
				<AutoSize Enabled="true" />
				<Layout HeaderVisible="false" RowSelectorsVisible="false" />
				<Mode AllowAddNew="false" AllowDelete="false" AllowUpdate="false" />
				<ActionBar Position="Top">
					<Actions>	
						<AddNew Enabled="false" /> <Delete Enabled="false" /> <ExportExcel Enabled="false" /> <AdjustColumns Enabled="false" />
					</Actions>
				</ActionBar>
				<Levels>
					<px:PXGridLevel DataMember="SourceFields" SortOrder="DisplayName">
						<Columns>
							<px:PXGridColumn DataField="Name" Visible="false" SyncVisible="false"  />
							<px:PXGridColumn DataField="DisplayName" Width="200px" AllowDragDrop="true" />
						</Columns>
					</px:PXGridLevel>
				</Levels>
				<CallbackCommands>
					<Refresh RepaintControlsIDs="edFormula" />
				</CallbackCommands>
				<ClientEvents Dragdrop="grid_DragDrop" />
			</px:PXGrid>
		</Template1>

		<Template2>
			<px:PXSplitContainer runat="server" ID="sp2" SplitterPosition="300" Height="300px" FixedPanel="Panel2">
				<AutoSize Enabled="true" />
				<Template1>
					<table style="width:100%;height:100px" cellspacing="0" cellpadding="0">
						<tr>
							<td style="width: 50%;padding: 0px">
								<table style="width:100%;height:100px" cellspacing="0" cellpadding="0">
									<tr>
										<td style="height: 50%">
											<px:PXGrid ID="gridInact" runat="server" SkinID="Details" Width="100%" DataSourceID="ds" Height="150px"
												CaptionVisible="true" Caption="Filters" AutoAdjustColumns="true" AllowPaging="false" SyncPosition="true" AllowDrop="ExactPosition">
												<AutoSize Enabled="true" />
												<Layout HeaderVisible="false" RowSelectorsVisible="false" />
												<ActionBar Position="Top">
													<CustomItems>
														<px:PXToolBarButton CommandSourceID="ds" CommandName="AddInactive" DisplayStyle="Image" ImageSet="main" ImageKey="AddNew">
															<ActionBar GroupIndex="0" Order="2" />
														</px:PXToolBarButton>
													</CustomItems>
													<Actions>	
														<AddNew Enabled="false" /> <ExportExcel Enabled="false" /> <AdjustColumns Enabled="false" />
													</Actions>
												</ActionBar>
												<Levels>
													<px:PXGridLevel DataMember="Inactive">
														<Columns>
															<px:PXGridColumn DataField="Expression" Visible="false" SyncVisible="false"  />
															<px:PXGridColumn DataField="Caption" Width="200px" AllowDragDrop="true" />
														</Columns>
													</px:PXGridLevel>
												</Levels>
												<ClientEvents AfterRowChange="grid_afterRowChange" CellClick="grid_cellClick" Dragdrop="grid_DragDrop" />
											</px:PXGrid>
										</td>
									</tr>
				
									<tr>
										<td>
											<px:PXSplitter ID="spl11" runat="server" SkinID="Horizontal" AllowCollapse="false" Size="2" 
												Enabled="false" BorderWidth="0px" Panel1MinSize="250" Panel2MinSize="250">
												<AutoSize Enabled="true" />
											</px:PXSplitter>
										</td>
									</tr>
				
									<tr>
										<td style="height: 50%">
										    <px:PXGrid ID="gridYDim" runat="server" SkinID="Details" Width="100%" DataSourceID="ds" Height="150px"
												CaptionVisible="true" Caption="Rows" AutoAdjustColumns="true" AllowPaging="false" SyncPosition="true" AllowDrop="ExactPosition">
												<AutoSize Enabled="true" />
												<Layout HeaderVisible="false" RowSelectorsVisible="false" />
												<ActionBar Position="Top">
													<CustomItems>
														<px:PXToolBarButton CommandSourceID="ds" CommandName="AddYDimension" DisplayStyle="Image" ImageSet="main" ImageKey="AddNew">
															<ActionBar GroupIndex="0" Order="2" />
														</px:PXToolBarButton>
													</CustomItems>
													<Actions>	
														<AddNew Enabled="false" /> <ExportExcel Enabled="false" /> <AdjustColumns Enabled="false" />
													</Actions>
												</ActionBar>
												<Levels>
													<px:PXGridLevel DataMember="YDimensions">
														<Columns>
															<px:PXGridColumn DataField="Expression" Visible="false" SyncVisible="false"  />
															<px:PXGridColumn DataField="Caption" Width="200px" AllowDragDrop="true" />
														</Columns>
													</px:PXGridLevel>
												</Levels>
												<ClientEvents AfterRowChange="grid_afterRowChange" CellClick="grid_cellClick" Dragdrop="grid_DragDrop" />
											</px:PXGrid>
										</td>
									</tr>
								</table>
							</td>
				
							<td>
								<px:PXSplitter ID="spl1" runat="server" Style="height: 100%" SaveSizeUnits="True" 
									AllowCollapse="false" Size="4" Enabled="false" Orientation="Vertical">
									<AutoSize Enabled="true" />
								</px:PXSplitter>
							</td>

							<td style="width: 50%;padding: 0px">
								<table style="width:100%;height:100px" cellspacing="0" cellpadding="0">
									<tr>
										<td style="height: 50%">
											<px:PXGrid ID="gridXDim" runat="server" SkinID="Details" Width="100%" DataSourceID="ds" Height="150px"
												CaptionVisible="true" Caption="Columns" AutoAdjustColumns="true" AllowPaging="false" SyncPosition="true" AllowDrop="ExactPosition">
												<AutoSize Enabled="true" />
												<Layout HeaderVisible="false" RowSelectorsVisible="false" />
												<ActionBar Position="Top">
													<CustomItems>
														<px:PXToolBarButton CommandSourceID="ds" CommandName="AddXDimension" DisplayStyle="Image" ImageSet="main" ImageKey="AddNew">
															<ActionBar GroupIndex="0" Order="2" />
														</px:PXToolBarButton>
													</CustomItems>
													<Actions>	
														<AddNew Enabled="false" /> <ExportExcel Enabled="false" /> <AdjustColumns Enabled="false" />
													</Actions>
												</ActionBar>
												<Levels>
													<px:PXGridLevel DataMember="XDimensions">
														<Columns>
															<px:PXGridColumn DataField="Expression" Visible="false" SyncVisible="false"  />
															<px:PXGridColumn DataField="Caption" Width="200px" AllowDragDrop="true" />
														</Columns>
													</px:PXGridLevel>
												</Levels>
												<ClientEvents AfterRowChange="grid_afterRowChange" CellClick="grid_cellClick" Dragdrop="grid_DragDrop" />
											</px:PXGrid>
										</td>
									</tr>
				
									<tr>
										<td>
											<px:PXSplitter ID="spl12" runat="server" SkinID="Horizontal" AllowCollapse="false" Size="2" 
												Enabled="false" BorderWidth="0px" Panel1MinSize="250" Panel2MinSize="250">
												<AutoSize Enabled="true" />
											</px:PXSplitter>
										</td>
									</tr>
				
									<tr>
										<td style="height: 50%">
											<px:PXGrid ID="gridFacts" runat="server" SkinID="Details" Width="100%" DataSourceID="ds" Height="150px" 
												CaptionVisible="true" Caption="Values" AutoAdjustColumns="true" AllowPaging="false" SyncPosition="true" AllowDrop="ExactPosition">
												<AutoSize Enabled="true" />
												<Layout HeaderVisible="false" RowSelectorsVisible="false" />
												<ActionBar Position="Top">
													<CustomItems>
														<px:PXToolBarButton CommandSourceID="ds" CommandName="AddFact" DisplayStyle="Image" ImageSet="main" ImageKey="AddNew">
															<ActionBar GroupIndex="0" Order="2" />
														</px:PXToolBarButton>
													</CustomItems>
													<Actions>	
														<AddNew Enabled="false" /> <ExportExcel Enabled="false" /> <AdjustColumns Enabled="false" />
													</Actions>
												</ActionBar>
												<Levels>
													<px:PXGridLevel DataMember="Facts">
														<Columns>
															<px:PXGridColumn DataField="Expression" Visible="false" SyncVisible="false"  />
															<px:PXGridColumn DataField="Caption" Width="200px" AllowDragDrop="true" />
														</Columns>
													</px:PXGridLevel>
												</Levels>
												<ClientEvents AfterRowChange="grid_afterRowChange" CellClick="grid_cellClick" Dragdrop="grid_DragDrop" />
											</px:PXGrid>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</Template1>

				<Template2>
					<%--<px:PXFormulaEditor ID="edFormula" runat="server" Width="150px" Hidden="true"
						DataSourceID="ds" FieldsViewName="SourceFields" FieldsFieldName="Name" CallbackUpdatable="true" />--%>
					<px:PXGrid ID="gridProps" runat="server" SkinID="Attributes" Width="100%" DataSourceID="ds" Height="150px" 
						CaptionVisible="true" Caption="Properties" AllowPaging="false" MatrixMode="false" OnRowDataBound="gridProps_RowDataBound">
						<AutoSize Enabled="true" />
						<Layout HeaderVisible="false" RowSelectorsVisible="false" />
						<Levels>
							<px:PXGridLevel DataMember="Properties" SortOrder="Order">
								<Columns>
									<px:PXGridColumn DataField="DisplayName" Width="150px" />
									<px:PXGridColumn DataField="Value" Width="150px" MatrixMode="true" />
								</Columns>
							</px:PXGridLevel>
						</Levels>
					</px:PXGrid>
				</Template2>
			</px:PXSplitContainer>
		</Template2>
	</px:PXSplitContainer>
</asp:Content>
