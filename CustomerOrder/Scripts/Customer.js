$(".search-btn").on("click", function () {
    LoadData();
});
$(".clear-btn").on("click", function () {
    $("#Search").val('');
    $("#EmpId").val('');
    $("#CityName").val('');
    $("#Sdate").val('');
    $("#Edate").val('');
    $("#curpageidx").val('');
    LoadData();
});
function LoadData() {
    $.ajax({
        url: '/Order/ListOrder',
        data: {

            search: $("#Search").val(),

            cityname: $("#CityName").val(),
            sdate: $("#Sdate").val(),
            edate: $("#Edate").val(),
            cPage: $("#curpageidx").val(),
            SortColumn: $("#SortColumn").val(),
            SortOrder: $("#SortOrder").val()
        }
    })
        .done(function (response) {
            console.log(response);
            console.log("success");
            $(".datadiv").html(response);
        })
        .fail(function (XMLHttpRequest, textStatus, errorThrown) {
            alert("FAIL");
        })
        .always(function () {
  
            console.log("always");
        });
}
function Sort(id) {
    $("#SortColumn").val(id);
    var las = $("#SortOrder").val();
    if (las == "ASC")
        $("#SortOrder").val("DESC");
    else
        $("#SortOrder").val("ASC");
    LoadData();

}

function Goto(index) {
    document.getElementById("curpageidx").value = index;
    LoadData();

}
$("#cust-btn").on("click", function () {
    toastr.success("Record Inserted succcesfuuly");
});
    
     
   