import frappe
from frappe.model.document import Document

class PackagingItem(Document):
    def validate(self):
        if not self.item_code:
            self.item_code = frappe.scrub(self.item_name)
