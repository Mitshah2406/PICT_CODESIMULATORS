var quill = new Quill('#editor-container', {
  modules: {
    toolbar: [
      [{
        header: [1, 2, false]
      }],
      ['bold', 'italic', 'underline'],
      [{ 'list': 'ordered'}, { 'list': 'bullet' }],
      [{ 'script': 'sub'}, { 'script': 'super' }],
      [{ 'color': [] }],          // dropdown with defaults from theme
      [{ 'font': [] }],
    ]
  },
  placeholder: 'Compose an epic...',
  theme: 'snow' // or 'bubble'
});


// When the submit button is clicked, update output
$('#btn-submitt').on('click', () => { 
  // Get HTML content
  var html = quill.root.innerHTML;

  // Copy HTML content in hidden form
  $('#quill-html').val( html )

  // Post form
  form-wizard1.submit();
})

// When the submit button is clicked, update output
$('#campaignFormSubmit1').on('click', () => { 
  // Get HTML content
  var html = quill.root.innerHTML;

  // Copy HTML content in hidden form
  $('#quill-htmll').val( html )

  // Post form
  formWizard2.submit();
})
