---
layout: post
title: "Wiring Client-Side Scripting Into WebForms Controls"
date: 2009-06-14 21:19:30 -0500
categories: []
tags: []
wordpress_id: 8
original_url: "https://joelholder.com/2009/06/14/using-jquery-with-webforms-controls/"
---
The scenario: We have an ASP.NET CheckListBox from which we want to ensure at least one option has been selected before allowing the user to click a button. Sounds simple enough, but we're going to use JQuery to do all of this work on the client.

ASP.NET MARKUP:

```html
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FileDownloadUserControl.ascx.cs" Inherits="FileDownloadUserControl" %>

<asp:CheckBoxList ID="chklstFilesAvailable" runat="server">

<asp:Button style="display: none" ID="btnDownload" runat="server" Text="Download" OnClick="btnDownload_Click" />
```

Simple and straightforward.. Now lets have a look at the HTML that this code results in. With three items bound to our CheckListBox, we get this:

RENDERED HTML MARKUP:

```html
<table id="ctl0_FileDownloadUserControl1_chklstFilesAvailable" border="0">
<tr>
<td>
<input id="ctl0_FileDownloadUserControl1_chklstFilesAvailable_0" type="checkbox" name="ctl0$FileDownloadUserControl1$chklstFilesAvailable$0" />
<label for="ctl0_FileDownloadUserControl1_chklstFilesAvailable_0">BLAH1_20090608.csv</label>
</td>
</tr>
<tr>
<td>
<input id="ctl0_FileDownloadUserControl1_chklstFilesAvailable_1" type="checkbox" name="ctl0$FileDownloadUserControl1$chklstFilesAvailable$1" />
<label for="ctl0_FileDownloadUserControl1_chklstFilesAvailable_1">BLAH2_20090608.csv</label>
</td>
</tr>
<tr>
<td>
<input id="ctl0_FileDownloadUserControl1_chklstFilesAvailable_2" type="checkbox" name="ctl0$FileDownloadUserControl1$chklstFilesAvailable$2" />
<label for="ctl0_FileDownloadUserControl1_chklstFilesAvailable_2">BLAH1_20090608.csv</label>
</td>
</tr>
</table>
<input type="submit" name="btnDownload" value="Download" id="btnDownload" />
```

WebForms has created a table, labels, and checkboxes. Note that the IDs have been changed from the original names we gave them. We have effectively lost control of our ID naming at this point. This makes it difficult to use JavaScript to target these elements after they've been rendered. Here is a workaround to target the CheckListBox and the Button post render.

First we get the mangled IDs and use those values in JQuery selectors to create JQuery objects. Then we pass them as parameters to the wireButtonShowToCheckListBox function in order to wire the click event of each checkbox to a nested anonymous function, which checks to see if at least one of the boxes are checked and, if so, shows the button.

JAVASCRIPT:

```javascript
<script type="text/javascript" language="javascript">

    $(document).ready(function() {
        var id = "<%= chklstFilesAvailable.ClientID %>";
        var chklist = $("#" + id);

        var btnId = "<%= btnDownload.ClientID %>";
        var button = $("#" + btnId);

        //reusable show/hide button wiring
        wireButtonShowToCheckListBox(chklist, button);
    });

    function wireButtonShowToCheckListBox(chklist, button) {
        chklist.find('input:checkbox').each(function() {
            var cb = $(this);
            cb.click(function() {

                var hit = false;
                chklist.find('input:checkbox').each(function() {
                    var checked = $(this).attr('checked');
                    if (checked)
                        hit = true;
                });

                if (hit == true) {
                    button.show();
                } else {
                    button.hide();
                }
            });
        });
    }

</script>
```

Thats it.. With this approach we can pass any CheckListBox and any Button to this function and achieve a very fast pure client-side solution to control when and if the user can click the button. The same basic approach can be used to target and wire other rendered WebForms controls. Enjoy..
