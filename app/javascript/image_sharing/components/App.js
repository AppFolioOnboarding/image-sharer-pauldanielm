import React from 'react';
import { Button, Form, FormGroup, Label, Input } from 'reactstrap';
import Header from './Header';

export default function App() {
  return (
    <div>
      <Header title="Tell us what you think" />
      <Form>
        <FormGroup>
          <Label for="name">Your Name</Label>
          <Input type="text" name="name" id="name" />
        </FormGroup>
        <FormGroup>
          <Label for="comments">Comments</Label>
          <Input type="textarea" name="comments" id="comments" />
        </FormGroup>
        <Button>Submit</Button>
        <footer>Copyright: Appfolio Inc. Onboarding</footer>
      </Form>
    </div>
  );
}

/* TODO: Add Prop Types check*/
