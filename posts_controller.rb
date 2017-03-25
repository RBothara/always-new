require "csv"
require "rubygems"
require "neo4j"
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  @@result=Hash.new
  @@from=0
  @@to=0


  def gscript
    uhash=Array.new
    pre=Hash.new
    evehash=Array.new
    session = Neo4j::Session.open(:server_db,"http://neo4j:123@localhost:7474")
    for i in 0..100
      uid=Random.rand(10)
      if((uhash.include?(uid))==false)
        uhash.push(uid)
        session.query("create (u:user{id:#{uid}})")
      end
      eveid=Random.rand(5)
      if((evehash.include?(eveid))==false)
        evehash.push(eveid)
        session.query("create (e:event{id:#{eveid}})")
      end
      t=Time.now
      if((pre.has_key?(uid))==false)
        pre['#{uid}']=i
        session.query("match (u:user{id:#{uid}}),(e:event{id:#{eveid}}) 
          create (a:action{id:#{i},timestamp:'#{t}',eventid:#{eveid}}),(u)-[:action]->(a),(e)-[:by]->(a)")
      else
        p=pre['#{uid}']
         session.query("match (u:user{id:#{uid}}),(e:event{id:#{eveid}}) 
          create (a:action{id:#{i},timestamp:'#{t}',eventid:#{eveid}}),(u)-[:action]->(a),(e)-[:by]->(a),
          (:action{id:#{p}})<-[:prev]-(a)")
        pre.replace({'#{uid}'=>'#{i}'})
      end
    end
  end

def new_db_insert
  uhash=Array.new
    pre=Hash.new
    evehash=Array.new
    session = Neo4j::Session.open(:server_db,"http://neo4j:123@localhost:7474")
 
     for i in 0...3
      uid=i
      if((uhash.include?(uid))==false)
        uhash.push(uid)
      end
        
      for j in 1...4
          eveid=j
          
          if((evehash.include?(eveid))==false)
           evehash.push(eveid)
           # session.query("create (e:event{id:#{eveid}})")
          end
          t=Time.now
          previous_id=3*i+j
          if((pre.has_key?(uid))==false)
          pre[uid]=previous_id

          @n=Post.new(p_id: uid, eid: eveid, t: t)
          session.query("match (u:user{id:#{uid}}),(e:event{id:#{eveid}}) 
            create (a:action{id:#{previous_id},timestamp:'#{t}',eventid:#{eveid}}),(u)-[:action]->(a),(e)-[:by]->(a)")
          else
          p=pre[uid]
           puts pre[uid]
           session.query("match (u:user{id:#{uid}}),(e:event{id:#{eveid}}),(b:action{id:#{p}})
            create (a:action{id:#{previous_id},timestamp:'#{t}',eventid:#{eveid}}),(u)-[:action]->(a),(e)-[:by]->(a),
            (b)<-[:prev{preeventid:#{eveid}}]-(a)")

         @n=Post.new(p_id: uid, eid: eveid, t: t,prev: p)
          pre[uid]=previous_id
          end
          @n.save
          puts "seq=#{previous_id},uid=#{uid},eventid=#{j},t=#{t}"
           
      end
  end
       for i in 5..7
      uid=i
      if((uhash.include?(uid))==false)
        uhash.push(uid)
       
      end
        
      for j in 1..4
        (j==4) ? eveid=3 : eveid=j
          if((evehash.include?(eveid))==false)
           evehash.push(eveid)
           
          end
          t=Time.now
          previous_id=4*i+j
          if((pre.has_key?(uid))==false)
          pre[uid]=previous_id
           @n=Post.new(p_id: uid, eid: eveid, t: t)
        
          else
          p=pre[uid]
           #puts pre[uid]
           @n=Post.new(p_id: uid, eid: eveid, t: t,prev: p)
          pre[uid]=previous_id
          end
          @n.save
          puts "seq=#{previous_id},uid=#{uid},eventid=#{j},t=#{t}"
           
      end
       end
  for i in 9..10
    uid=i
    if((uhash.include?(uid))==false)
      uhash.push(uid)
     
    end

    for j in 1..4
      if(j==1)
        eveid=1
      else
      (j==2) ? eveid=1 : eveid=j-1
    end
      if((evehash.include?(eveid))==false)
        evehash.push(eveid)
       
      end
      t=Time.now
      previous_id=4*i+j
      if((pre.has_key?(uid))==false)
        pre[uid]=previous_id
         @n=Post.new(p_id: uid, eid: eveid, t: t)
      else
        p=pre[uid]
        #puts pre[uid]
        @n=Post.new(p_id: uid, eid: eveid, t: t,prev: p)
        pre[uid]=previous_id
      end
      @n.save
      #puts "seq=#{previous_id},uid=#{uid},eventid=#{j},t=#{t}"

    end
  end
  # for i in 141..150
  #   uid=i
  #   if((uhash.include?(uid))==false)
  #     uhash.push(uid)
    
  #   end

  #   for j in 1..5
  #     (j==4) ? eveid=1 : eveid=j
  #     (j==5) ? eveid=2 : eveid=j
  #     if((evehash.include?(eveid))==false)
  #       evehash.push(eveid)
       
  #     end
  #     t=Time.now
  #     previous_id=5*i+j
  #     if((pre.has_key?(uid))==false)
  #       pre[uid]=previous_id
  #        @n=Post.new(p_id: uid, eid: eveid, t: t)
  #     else
  #       p=pre[uid]
  #        @n=Post.new(p_id: uid, eid: eveid, t: t,prev: p)
  #       pre[uid]=previous_id
  #     end
  #     @n.save
  #     #puts "seq=#{previous_id},uid=#{uid},eventid=#{j},t=#{t}"

  #   end
  # end
  #   for i in 0...30000
      
  #     uid=Random.rand(20)
  #     if((uhash.include?(uid))==false)
  #       uhash.push(uid)
        
  #     end
  #     eveid=Random.rand(4..6)
  #     if((evehash.include?(eveid))==false)
  #       evehash.push(eveid)
        
  #     end
  #     t=Time.now
  #     if((pre.has_key?(uid))==false)
  #       pre[uid]=i
  #      @n=Post.new(p_id: uid, eid: eveid, t: t)
  #     else
  #       p=pre[uid]
  #       puts pre[uid]
  #       @n=Post.new(p_id: uid, eid: eveid, t: t,prev: p)
  #       pre[uid]=i
  #     end
  #   end

end

def csv_file_upload
 # session = Neo4j::Session.open(:server_db,"http://neo4j:neo4j@localhost:7474")
    @posts = Post.all
    distinct_user_id=@posts.distinct(:p_id)
    distinct_event_id=@posts.distinct(:eid)
   render plain: distinct_user_id

    CSV.open("/home/atom/workspace/amura/graph/userid.csv", "w") do |userid|
      userid << ["userid"]
      distinct_user_id.each do |id|
      userid << [id]
    end
    end

    CSV.open("/home/atom/workspace/amura/graph/eventid.csv", "w") do |eventid|
      eventid << ["eventid"]
      distinct_event_id.each do |id|
      eventid << [id]
      end
    end

    CSV.open("/home/atom/workspace/amura/graph/actions.csv", "w") do |actions|
      actions << ["actionseq" , "userid" , "eventid" , "timestamp"]
      @posts.each do |i|
      actions << [i.action_id,i.p_id,i.eid,i.t]
      end
    end

    seq=Hash.new{}
    seq_id=Hash.new{}
    @posts.each do |i|
      if(seq.has_key?(i.p_id))
        seq[i.p_id].push(i.action_id)
      else
        seq[i.p_id]=Array.new
        seq[i.p_id].push(i.action_id)
      end
    end
# render plain: "entering next_action.csv"
CSV.open("/home/atom/workspace/amura/graph/next_action.csv", "w") do |actions|
  actions << ["present_action","previous_action"]
  id=0
  seq.each do |key,value|
    seq1=value
    seq_length=seq1.size-1
    until seq_length<1 do
      previous=seq_length-1
      actions << [seq1[seq_length],seq1[previous]]
      seq_length-=1 
    end
    id+=1
  end
end


end

def con
session = Neo4j::Session.open(:server_db,"http://neo4j:123@localhost:7474")
for i in 0..120
  session.query("create (:user{id:#{i}})")
end
for i in 1..10
  session.query("create (:event{id:#{i}})")
end
end

  def index 
  # con()  
    # csv_file_upload()
     # event_sequnce_input()
    @session = Neo4j::Session.open(:server_db,"http://neo4j:amura@localhost:7474")
    result = @session.query("match (e:event)return distinct e.id")
    @a = result.map do |row|
      row["e.id"]
    end
     result=@session.query("match (a:action) return min(a.timestamp) as min, max(a.timestamp) as max" )
     result.each do |row|
      @from=row["min"]
      @to=row["max"]
      @from=Time.at(@from)
      @to=Time.at(@to)
     end

  end
  def event_sequnce_input
    session = Neo4j::Session.open(:server_db,"http://neo4j:amura@localhost:7474")
    result = session.query("match (e:event)return distinct e.id")
    @a = result.map do |row|
      row["e.id"]
    end
    
  end

  def show
  
  end


  def new
   @r=@@result
  end

  def edit
  end

  def create
      event_hash= params["event"]
      from=params["from"]
      # to=params["to"]
      to=1451558319117
    #  event_hash=Hash.new 
    # event_hash={"1"=>"1", "2"=>"2", "3"=>"3", "4"=>"3"}
       @sequence=event_hash['1']
       # render plain: event_hash
       @session = Neo4j::Session.open(:server_db,"http://neo4j:amura@localhost:7474")
       @f=Hash.new
       # sample=Array.new
      @query="match (e:event{id:#{event_hash['1']}})-[:by]->(a"+1.to_s+":action)"
      result=@session.query(@query+" where a1.timestamp>#{from.to_i} and a1.timestamp<#{to.to_i} return count(e)")
      # sample.push(@query+"where a1.timestamp>#{from.to_i} and a1.timestamp<#{to.to_i} return count(e)")
      result.each do |row|
     @f[@sequence]=row["count(e)"]
      end
      @distinct="(e)-->(a"+1.to_s+")"
       i=2
      event_hash.each do |k,event|
        
        if(i>2)
          @sequence+=","+event
          @query+="<-[:prev*0..]-(a"+(i.to_s) +":action{eventid:#{event}})"
        @distinct+="<--(a"+(i.to_s)+")"
        @date_query=" where a1.timestamp>#{from.to_i} and a"+(i.to_s)+".timestamp<#{to.to_i} "
        @distinct_query="<-[:action]-(:user)"+@date_query+"  with " +@distinct + "<--(:user) as coll with distinct coll where not coll=[] return count(coll) as result"
        # @f.push(@query+@distinct_query)
        result=@session.query(@query+@distinct_query)
        # sample.push(@query+@distinct_query)
        result.each do |row|
          @f[@sequence]=row["result"]
        end
        end
         i+=1
      end  
       # render plain: @f       
     @@result=@f
          redirect_to action: :new        
  end
  def fresult
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_fresult }
          
  format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_post
      # @post = Post.find(params[:post])
    end

    def post_params
      params.require(:post).permit(:p_id, :eid, :t)
    end
end


<<-DOC
match p=(a:action{eventid:2})<-[:prev*0..]-(b:action) where b.eventid=1 return extract(x in nodes(p)|x.id)

load csv with headers from "file:///home/atom/workspace/amura/graph/userid.csv" as line create (u:user{id: toInt(line.userid)});
+-------------------+
| No data returned. |
+-------------------+
Nodes created: 10
Properties set: 10
Labels added: 10
131 ms
load csv with headers from "file:///home/atom/workspace/amura/graph/eventid.csv" as line create (u:event{id: toInt(line.eventid)});
+-------------------+
| No data returned. |
+-------------------+
Nodes created: 3
Properties set: 3
Labels added: 3
152 ms
 load csv with headers from "file:///home/atom/workspace/amura/graph/actions.csv" as  line create (u:action{id: toInt(line.actionseq),timestamp: toInt(line.timestamp),   eventid: toInt(line.eventid)});
+-------------------+
| No data returned. |
+-------------------+
Nodes created: 1000
Properties set: 3000
Labels added: 1000
304 ms
 load csv with headers from "file:///home/atom/workspace/amura/graph/actions.csv" as line match (u:user {id: toInt(line.userid)}),(a:action{id: toInt(line.actionseq)}),(e:event{id: toInt(line.eventid)}) create (u)-[:action]->(a),(e)-[:by]->(a) ;
+-------------------+
| No data returned. |
+-------------------+
Relationships created: 2000
3400 ms
 load csv with headers from "file:///home/atom/workspace/amura/graph/next_action.csv" as line match (a:action {id: toInt(line.present_action)}),(b:action{id: toInt(line.previous_action)}) create (b)<-[:prev{preveventid:b.eventid}]-(a);
+-------------------+
| No data returned. |
+-------------------+
Relationships created: 990
5245 ms
neo4j-sh (?)$ 

match p=(a:action{eventid:2})<-[:prev*0..]-(b:action) where b.eventid=1 RETURN distinct(last(nodes(p)));


DOC


<<-DOC
neo4j-sh (?)$ match (a:action{eventid:2})<-[link:prev*0..]-(b:action{eventid:1}) where all (rels in link where not rels.previd=2) return count(b);
+----------+
| count(b) |
+----------+
| 12       |
+----------+
1 row
90 ms
neo4j-sh (?)$ match (a:action{eventid:2})<-[link:prev*0..]-(b:action{eventid:1}) where all (rels in link where not rels.previd=1) return count(b);
+----------+
| count(b) |
+----------+
| 10       |
+----------+
1 row
20 ms
DOC