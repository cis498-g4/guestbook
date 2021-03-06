<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/header.jsp"></jsp:include>

<!-- TODO only display if filter active -->
<p hidden>Surveys {for|by} this {event|presenter|user} are {very|somewhat} {positive|negative}</p>

<table class="table table-responsive" id="survey-list">
    <thead>
        <tr>
            <th>Event</th>
            <th>Presenter</th>
            <th>Event Date</th>
            <th>Reviewer</th>
            <th>Submission Date</th>
            <th hidden>Overall Satisfaction</th>
            <th hidden>Information Quality</th>
            <th hidden>Information Relevance</th>
            <th hidden>Presenter Knowledge</th>
            <th hidden>Presentation Quality</th>
            <th hidden>Return Likelihood</th>
            <th hidden>Event Organization</th>
            <th hidden>Event Staff</th>
            <th hidden>Staff Responsiveness</th>
            <th hidden>Recommend Likelihood</th>
            <th></th>
        </tr>
    </thead>

    <tbody>
        <c:forEach items="${surveys}" var="survey">
            <tr>
                <td>${survey.event.name}</td>
                <td>${survey.event.presenter.lastName}, ${survey.event.presenter.firstName}</td>
                <td>${survey.event.startDateTime.getMonthValue()}/${survey.event.startDateTime.getDayOfMonth()}/${survey.event.startDateTime.getYear()}</td>
                <td>${survey.user.lastName}, ${survey.user.firstName}</td>
                <td>
                    ${survey.submissionDateTime.getMonthValue()}/${survey.submissionDateTime.getDayOfMonth()}/${survey.submissionDateTime.getYear()}
                    ${survey.submissionDateTime.getHour()}:${survey.submissionDateTime.getMinute() < 10 ? "0" : ""}${survey.submissionDateTime.getMinute()}
                </td>

                <c:forTokens delims="," items="01,02,03,04,05,06,07,08,09,10" var="num">
                    <td hidden>${survey.responses.get("response_".concat(num))}</td>
                </c:forTokens>

                <td>
                    <form action="show-survey-info">
                        <input type="hidden" name="id" value="${survey.id}">
                        <input type="submit" class="btn btn-link btn-block" value="view results">
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>

</table>

<jsp:include page="/WEB-INF/templates/footer.jsp"></jsp:include>

<script>
    // jQuery DataTables https://datatables.net/
    $(document).ready(function() {
        var table = $('#survey-list').DataTable( {
            dom: '<"row"<"col-sm-12"i>>' +
            '<"row"<"col-sm-6"l><"col-sm-6"f>>' +
            '<"row"<"col-sm-12"rt>>' +
            '<"spacer_20">' +
            '<"row"<"col-sm-6"B><"col-sm-6"p>>',
            columnDefs: [ { orderable: false, targets: [15] },
                { render: $.fn.dataTable.render.ellipsis(25), targets: [0, 1, 3] } ],
            buttons: [
                { extend: 'csv', text: 'Download CSV', className: 'btn-primary' }
            ]
        });
    });

    // render ellipses for data longer than maxLen
    $.fn.dataTable.render.ellipsis = function (maxLen) {
        return function (data, type, row) {
            return type === 'display' && data.length > maxLen ?
                data.substr(0, maxLen) +'&hellip;' :
                data;
        }
    };

</script>

</body>
</html>

