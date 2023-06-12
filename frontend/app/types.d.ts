interface NavItem {
  name: string;
  isauth?: boolean;
}

interface NavItems {
  [url: string]: NavItem;
}