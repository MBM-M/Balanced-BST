require_relative 'Node.rb'

class Tree
  attr_accessor :root


  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty?

    mid = array.length / 2
    root = Node.new(array[mid])

    left = build_tree(array[0...mid])
    right = build_tree(array[mid+1..-1])

    root.left = left unless left.nil?
    root.right = right unless right.nil?

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  #insert accepts a value to insert
  def insert(value, root = @root)
    return Node.new(value) if root.nil?
    
    if root.data == value
      return root 
    elsif root.data < value
      root.right = insert(value, root.right)
    else
      root.left = insert(value, root.left)
    end
    root
  end

  #get_successor works with #del_node to replace the deleted node
  def get_successor(curr)
    curr = curr.right
    while (curr =! nil) && (curr.left =! nil)
      curr.left
    end
    curr
  end

  #del_node accepts a value to delete
  def del_node(value, root = @root)
    return root if root == nil

    if root.data > value
      root.left = del_node(value, root.left)
    elsif root.data < value
      root.right = del_node(value, root.right)
    else
      return root.right if root.left == nil
      return root.left if root.right == nil
      succ = get_successor(root)
      root.data = succ.data
      root.right = del_node(succ.data, root.right)
    end
    root
  end

  #find accepts a value and returns the node with the given value
  def find(value, root = @root)
    return root if root.data == value
    return nil if value == nil

    if value < root.data
      find(value, root.left) if root.left
    else
      find(value, root.right) if root.right
    end
  end

  #traveses the tree in breadth-first order
  def level_order(block = [])
    return [] if @root.nil?
    queue = [@root]

    until queue.empty?
      current = queue.shift
      block << current.data
      
      queue.push(current.left) if current.left
      queue.push(current.right) if current.right
    end

    block
  end

  def inorder(root = @root, values = [])
    return values if root.nil?
  
    inorder(root.left, values)
    values << root.data
    inorder(root.right, values)
    values
  end
  

  def preorder(root = @root)
    return if root.nil?

    print "#{root.data} "
    preorder(root.left)
    preorder(root.right)
  end

  def postorder(root = @root)
    return if root.nil?

    postorder(root.left)
    postorder(root.right)
    printf "#{root.data} "
  end

  def height(root = @root)
    return 0 if root.nil?

    left_hight = height(root.left)
    right_height = height(root.right)

    [left_hight, right_height].max + 1
  end

  def depth(root, parent = @root, egdes = 0)
    return -1 if root.nil?
    return egdes if root == parent

    if root.data < parent.data
      depth(root, parent.left, egdes + 1)
    elsif root.data > parent.data
      depth(root, parent.right, egdes + 1)
    end
  end

  def balanced?(node = @root)
    return true if node.nil?

    # Left and right subtree heights
    left_height = height(node.left)
    right_height = height(node.right)

    # we also need to check recursevely for is the subtrees are balanced
    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    values = inorder
    @root = build_tree(values.uniq.sort)
  end
end

try = Tree.new(Array.new(15){rand(1..100)})
p try
try.pretty_print
puts '__________________________________'
p try.root.data
p try.find(9)
puts '__________________________________'
try.insert(20)
try.pretty_print
puts '__________________________________'
p try.balanced?
try.rebalance
p try.balanced?